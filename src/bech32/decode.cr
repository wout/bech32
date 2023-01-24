module Bech32
  extend self

  {% begin %}
    ALPHABET = {
      {% for char, i in "qpzry9x8gf2tvdw0s3jn54khce6mua7l".split("") %}
        {{char}}: {{i}}.to_u8,
      {% end %}
    }
  {% end %}

  enum Encoding
    Bech32  =          1
    Bech32M = 0x2bc830a3
  end

  def decode(
    value : String,
    limit = 90,
    encoding = Encoding::Bech32
  ) : Tuple(String, Bytes)
    prefix, data, upcase = sanitize_and_parse_parts(value, limit)
    check, chars = prefix_check(prefix), [] of UInt8

    data.each.with_index do |c, i|
      raise Exception.new("Unknown character #{c}") unless v = ALPHABET[c]?
      check = polymod_step(check) ^ v
      chars.push(v) if i + 6 < data.size
    end

    check == encoding.value || raise Exception.new("Invalid checksum #{check}")

    {
      upcase ? prefix.upcase : prefix,
      Bytes.new(chars.size).fill { |i| chars[i] },
    }
  end

  private def prefix_check(prefix : String)
    chars = prefix.to_slice
    check = chars.reduce(1) do |memo, c|
      c >= 33 && c <= 126 || raise Exception.new("Invalid prefix '#{prefix}'")
      polymod_step(memo) ^ (c >> 5)
    end
    chars.reduce(polymod_step(check)) do |memo, c|
      polymod_step(memo) ^ (c & 0x1f)
    end
  end

  private def polymod_step(p : Int32) : Int32
    b = p >> 25
    ((p & 0x1ffffff) << 5) ^
      (-((b >> 0) & 1) & 0x3b6a57b2) ^
      (-((b >> 1) & 1) & 0x26508e6d) ^
      (-((b >> 2) & 1) & 0x1ea119fa) ^
      (-((b >> 3) & 1) & 0x3d4233dd) ^
      (-((b >> 4) & 1) & 0x2a1462b3)
  end

  private def sanitize_and_parse_parts(value, limit) : Tuple(String, Array(String), Bool)
    value.size >= 8 ||
      raise Exception.new("'#{value}' is too short")
    value.size <= limit ||
      raise Exception.new("Exceeds length limit")
    value == (downcased = value.downcase) || value == value.upcase ||
      raise Exception.new("Mixed-case string")
    (split = value.rindex('1')) ||
      raise Exception.new("No separator character")
    split != 0 ||
      raise Exception.new("Missing prefix")

    prefix, data = downcased[0...split], downcased[split.succ..]

    data.size >= 6 || raise Exception.new("Data part '#{data}' is too short")

    {prefix, data.split(""), value == value.upcase}
  end
end

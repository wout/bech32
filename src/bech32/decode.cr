module Bech32
  extend self

  def decode(
    value : String,
    limit = 90,
    encoding = Encoding::Bech32
  ) : Tuple(String, Words)
    prefix, data, upcase = sanitize_and_parse_parts(value, limit)
    check, words = prefix_check(prefix), Words.new

    data.each.with_index do |c, i|
      raise Exception.new("Unknown character #{c}") unless v = ALPHABET[c]?
      check = polymod_step(check) ^ v
      words.push(v) if i + 6 < data.size
    end

    check == encoding.value || raise Exception.new("Invalid checksum #{check}")

    {upcase ? prefix.upcase : prefix, words}
  end

  private def prefix_check(prefix : String)
    words = prefix.to_slice
    check = words.reduce(1) do |memo, w|
      w >= 33 && w <= 126 || raise Exception.new("Invalid prefix '#{prefix}'")
      polymod_step(memo) ^ (w >> 5)
    end
    words.reduce(polymod_step(check)) do |memo, w|
      polymod_step(memo) ^ (w & 0x1f)
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

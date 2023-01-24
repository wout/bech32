module Bech32
  extend self

  def decode(value : String, limit : Int32 = 90)
    prefix, data = sanitize_and_parse_parts(value, limit)
  end

  private def prefix_check(prefix : String)
    check = 1
    prefix.bytes.each do |c|
      c >= 33 && c <= 126 || raise Exception.new("Invalid prefix '#{prefix}'")
      check = polymod_step(check) ^ (c >> 5)
    end
    check = polymod_step(check)
    prefix.bytes.each do |c|
      check = polymod_step(check) ^ (c & 0x1f)
    end
    check
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

  private def sanitize_and_parse_parts(value, limit) : Tuple(String, String)
    value.size >= 8 ||
      raise Exception.new("'#{value}' is too short")
    value.size <= limit ||
      raise Exception.new("Exceeds length limit")
    value == value.downcase || value == value.upcase ||
      raise Exception.new("Mixed-case string")
    (split = value.rindex('1')) ||
      raise Exception.new("No separator character")
    split != 0 ||
      raise Exception.new("Missing prefix")

    value = value.downcase
    prefix, data = value[0...split], value[split.succ..]

    data.size >= 6 ||
      raise Exception.new("Data part '#{data}' is too short")

    {prefix, data}
  end
end

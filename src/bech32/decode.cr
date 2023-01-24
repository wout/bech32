module Bech32
  extend self

  def decode(value : String, limit : Int32 = 90)
    prefix, data = sanitize_and_parse_parts(value, limit)
  end

  private def sanitize_and_parse_parts(value, limit) : Tuple(String, String)
    value.size >= 8 ||
      raise DecodeException.new("'#{value}' is too short")
    value.size <= limit ||
      raise DecodeException.new("Exceeds length limit")
    value == value.downcase || value == value.upcase ||
      raise DecodeException.new("Mixed-case string")
    (split = value.rindex('1')) ||
      raise DecodeException.new("No separator character")
    split != 0 ||
      raise DecodeException.new("Missing prefix")

    value = value.downcase
    prefix, data = value[0...split], value[split.succ..]

    data.size >= 6 ||
      raise DecodeException.new("Data part '#{data}' is too short")

    {prefix, data}
  end
end

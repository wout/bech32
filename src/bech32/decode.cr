module Bech32
  extend self

  def decode(
    value : String,
    limit = LIMIT,
    encoding = Encoding::Bech32
  ) : Tuple(String, Bytes)
    prefix, data, upcase = sanitize_and_parse_parts(value, limit)
    check, data_size, words = prefix_check(prefix), data.size, IO::Memory.new

    data.each_char.with_index do |c, i|
      raise CharException.new("Unknown character #{c}") unless v = ALPHABET_MAP[c]?
      check = polymod_step(check) ^ v
      words.write_byte v if i + 6 < data_size
    end

    check == encoding.value || raise ChecksumException.new("Invalid checksum #{check}")

    {upcase ? prefix.upcase : prefix, words.to_slice}
  end

  private def sanitize_and_parse_parts(value, limit) : Tuple(String, String, Bool)
    value.size >= 8 ||
      raise LengthException.new("'#{value}' is too short")
    value.size <= limit ||
      raise LimitException.new("Exceeds length limit")
    value == (downcased = value.downcase) || value == value.upcase ||
      raise CaseException.new("Mixed-case string")
    (split = value.rindex('1')) ||
      raise PrefixException.new("No separator character")
    split != 0 ||
      raise PrefixException.new("Missing prefix")

    prefix, data = downcased[0...split], downcased[split.succ..]

    data.size >= 6 || raise LengthException.new("Data part '#{data}' is too short")

    {prefix, data, value == value.upcase}
  end
end

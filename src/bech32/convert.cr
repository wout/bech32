module Bech32
  extend self

  def to_words(bytes : Bytes) : Bytes
    bytes_from_array(convert_bits(bytes, 8, 5, true))
  end

  def from_words(words : Bytes) : Bytes
    bytes_from_array(convert_bits(words, 5, 8, false))
  end

  private def convert_bits(
    data : Bytes,
    from : Int32,
    to : Int32,
    padding : Bool
  ) : Array(UInt8)
    acc, bits, result = 0, 0, Array(UInt8).new
    max_v, max_acc = (1 << to) - 1, (1 << (from + to - 1)) - 1

    data.each do |v|
      raise CharException.new("Invalid bit") if v < 0 || (v >> from) != 0
      acc = ((acc << from) | v) & max_acc
      bits += from
      while bits >= to
        bits -= to
        result << ((acc >> bits) & max_v).to_u8
      end
    end

    if padding
      result << ((acc << (to - bits)) & max_v).to_u8 unless bits == 0
    else
      raise PaddingException.new("Excess padding") if bits >= from
      raise PaddingException.new("Non-zero padding") if ((acc << (to - bits)) & max_v) != 0
    end

    result
  end
end

module Bech32
  extend self

  def to_words(bytes : Bytes) : Words
    convert(bytes)
  end

  def from_words(words : Words) : Bytes
    convert(words)
  end

  def convert(bytes : Bytes) : Words
    convert_bits(bytes, 8, 5, true).map(&.to_u8)
  end

  def convert(words : Words) : Bytes
    bits = convert_bits(words, 5, 8, false)
    Bytes.new(bits.size).fill { |i| bits[i].to_u8 }
  end

  private def convert_bits(
    data : Bytes | Words,
    from : Int32,
    to : Int32,
    padding : Bool
  ) : Array(Int32)
    acc = 0
    bits = 0
    ret = Array(Int32).new
    maxv = (1 << to) - 1
    max_acc = (1 << (from + to - 1)) - 1

    data.each do |v|
      raise Exception.new("Invalid bit") if v < 0 || (v >> from) != 0
      acc = ((acc << from) | v) & max_acc
      bits += from
      while bits >= to
        bits -= to
        ret << ((acc >> bits) & maxv)
      end
    end

    if padding
      ret << ((acc << (to - bits)) & maxv) unless bits == 0
    else
      raise Exception.new("Excess padding") if bits >= from
      raise Exception.new("Non-zero padding") if ((acc << (to - bits)) & maxv) != 0
    end

    ret
  end
end

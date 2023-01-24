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

  private def bytes_from_array(array : Array(UInt8)) : Bytes
    Bytes.new(array.size).fill { |i| array[i] }
  end
end

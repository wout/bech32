module Bech32
  extend self

  ALPHABET = "qpzry9x8gf2tvdw0s3jn54khce6mua7l"
  LIMIT    = 90

  {% begin %}
    ALPHABET_MAP = {
      {% for char, i in ALPHABET.split("") %}
        {{char}}: {{i}}.to_u8,
      {% end %}
    }
  {% end %}

  enum Encoding
    Bech32  =          1
    Bech32M = 0x2bc830a3
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

  private def bytes_from_array(array : Array(UInt8)) : Bytes
    Bytes.new(array.size).fill { |i| array[i] }
  end
end

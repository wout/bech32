module Bech32
  extend self

  {% begin %}
    ALPHABET = {
      {% for char, i in "qpzry9x8gf2tvdw0s3jn54khce6mua7l".split("") %}
        {{char}}: {{i}}.to_u8,
      {% end %}
    }
  {% end %}

  alias Words = Array(UInt8)

  enum Encoding
    Bech32  =          1
    Bech32M = 0x2bc830a3
  end
end

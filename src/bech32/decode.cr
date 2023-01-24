module Bech32
  extend self

  def decode(value : String, limit : Int32 = 90)
    raise DecodeException.new("'#{value}' is too short") if value.size < 8
    raise DecodeException.new("Exceeds length limit") if value.size > limit
  end
end

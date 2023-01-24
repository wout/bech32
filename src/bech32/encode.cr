module Bech32
  extend self

  def encode(
    prefix : String,
    words : Bytes,
    limit = LIMIT,
    encoding = Encoding::Bech32
  ) : String
    prefix.size + 7 + words.size <= limit ||
      raise Exception.new("Exceeds length limit")

    upcase = prefix != (prefix = prefix.downcase)
    string = String.build do |io|
      check = prefix_check(prefix)
      io << prefix
      io << 1
      words.each do |v|
        raise Exception.new("Non 5-bit word") if v >> 5 != 0
        check = polymod_step(check) ^ v
        io << ALPHABET[v]
      end
      6.times { check = polymod_step(check) }
      6.times do |i|
        v = ((check ^ encoding.value) >> 5 * (5 - i)) & 31
        io << ALPHABET[v]
      end
    end

    upcase ? string.upcase : string
  end
end

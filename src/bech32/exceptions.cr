module Bech32
  class Exception < Exception; end

  class CaseException < Bech32::Exception; end

  class CharException < Bech32::Exception; end

  class ChecksumException < Bech32::Exception; end

  class LengthException < Bech32::Exception; end

  class LimitException < Bech32::Exception; end

  class Non5BitException < Bech32::Exception; end

  class PaddingException < Bech32::Exception; end

  class PrefixException < Bech32::Exception; end
end

require "../spec_helper"

describe Bech32 do
  describe "#decode" do
    it "does" do
      s = "split1checkupstagehandshakeupstreamerranterredcaperred2y9e3w"
      Bech32.decode(s)
    end

    it "raises if the string is too short" do
      expect_raises(Bech32::DecodeException, "'blabla1' is too short") do
        Bech32.decode("blabla1")
      end
    end

    it "raises if the string is too long" do
      expect_raises(Bech32::DecodeException, "Exceeds length limit") do
        Bech32.decode("abcdefghijklmnopqrstuvwxyz", 25)
      end
    end

    it "raises with a mixed-case string" do
      expect_raises(Bech32::DecodeException, "Mixed-case string") do
        Bech32.decode("aBcDeFgH")
      end
    end

    it "raises if no separator character could be found" do
      expect_raises(Bech32::DecodeException, "No separator character") do
        Bech32.decode("abcdefghijklmnopqrstuvwxyz")
      end
    end

    it "raises without a prefix" do
      expect_raises(Bech32::DecodeException, "Missing prefix") do
        Bech32.decode("1abcdefghijklmnopqrstuvwxyz")
      end
    end

    it "raises if data is too short" do
      expect_raises(Bech32::DecodeException, "Data part 'check' is too short") do
        Bech32.decode("split1check")
      end
    end
  end
end

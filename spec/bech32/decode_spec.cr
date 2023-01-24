require "../spec_helper"

describe Bech32 do
  describe "#decode" do
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
  end
end

require "../spec_helper"

describe Bech32 do
  describe "#to_words" do
    it "converts bytes to words" do
      Bech32.to_words(VALID_CONVERT[:bytes])
        .should eq(VALID_CONVERT[:words])
    end
  end

  describe "#to_words" do
    it "converts words to bytes" do
      Bech32.from_words(VALID_CONVERT[:words])
        .should eq(VALID_CONVERT[:bytes])
    end
  end
end

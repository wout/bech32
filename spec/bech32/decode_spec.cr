require "../spec_helper"

describe Bech32 do
  describe ".decode" do
    {% for expected in VALID_BECH32 %}
      it "decodes string with prefix '{{expected[:prefix].id}}'" do
        expected = {{expected}}

        if limit = expected[:limit]?
          prefix, words = Bech32.decode(expected[:string], limit)
        else
          prefix, words = Bech32.decode(expected[:string])
        end

        prefix.should eq(expected[:prefix])
        words.should eq(expected[:words])
      end
    {% end %}

    {% for expected in INVALID_BECH32_DECODE %}
      it "fails to decode '{{expected[:string].id}}'" do
        expect_raises(Bech32::Exception, {{expected[:excpetion]}}) do
          Bech32.decode({{expected[:string]}})
        end
      end
    {% end %}

    {% for expected in VALID_BECH32M %}
      it "decodes string with prefix '{{expected[:prefix].id}}'" do
        expected = {{expected}}
        encoding = Bech32::Encoding::Bech32M

        if limit = expected[:limit]?
          prefix, words = Bech32.decode(expected[:string], limit, encoding)
        else
          prefix, words = Bech32.decode(expected[:string], encoding: encoding)
        end

        prefix.should eq(expected[:prefix])
        words.should eq(expected[:words])
      end
    {% end %}

    {% for expected in INVALID_BECH32M_DECODE %}
      it "fails to decode '{{expected[:string].id}}'" do
        expect_raises(Bech32::Exception, {{expected[:excpetion]}}) do
          Bech32.decode({{expected[:string]}}, encoding: Bech32::Encoding::Bech32M)
        end
      end
    {% end %}

    it "raises if the string is too short" do
      expect_raises(Bech32::Exception, "'blabla1' is too short") do
        Bech32.decode("blabla1")
      end
    end

    it "raises if the string is too long" do
      expect_raises(Bech32::Exception, "Exceeds length limit") do
        Bech32.decode("abcdefghijklmnopqrstuvwxyz", 25)
      end
    end

    it "raises with a mixed-case string" do
      expect_raises(Bech32::Exception, "Mixed-case string") do
        Bech32.decode("aBcDeFgH")
      end
    end

    it "raises if no separator character could be found" do
      expect_raises(Bech32::Exception, "No separator character") do
        Bech32.decode("abcdefghijklmnopqrstuvwxyz")
      end
    end

    it "raises without a prefix" do
      expect_raises(Bech32::Exception, "Missing prefix") do
        Bech32.decode("1abcdefghijklmnopqrstuvwxyz")
      end
    end

    it "raises if data is too short" do
      expect_raises(Bech32::Exception, "Data part 'check' is too short") do
        Bech32.decode("split1check")
      end
    end
  end
end

require "../spec_helper"

describe Bech32 do
  describe "#decode" do
    {% for expected in VALID_BECH32 %}
      it "decodes string with prefix #{{{expected}}[:prefix]}" do
        expected = {{expected}}

        if limit = expected[:limit]?
          prefix, butes = Bech32.decode(expected[:string], limit)
        else
          prefix, butes = Bech32.decode(expected[:string])
        end

        prefix.should eq(expected[:prefix])
        butes.should eq(expected[:bytes])
      end
    {% end %}

    # it "does" do
    #   # s = "split1checkupstagehandshakeupstreamerranterredcaperred2y9e3w"
    #   s = "addr_test1qqzdl92zkvjpy95ggya0ddwke22c28x68t06s26dmf7e5vglaeslj4r7yyt83ktudh92uxs4qu08x8klfx4psnz8ka7qg85knz"
    #   Bech32.decode(s, 108)
    # end

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

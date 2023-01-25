require "../spec_helper"

describe Bech32 do
  describe ".encode" do
    {% for example in VALID_BECH32 %}
      it "encodes string with prefix '{{example[:prefix].id}}'" do
        example = {{example}}

        if limit = example[:limit]?
          string = Bech32.encode(example[:prefix], example[:words], limit: limit)
        else
          string = Bech32.encode(example[:prefix], example[:words])
        end

        string.should eq(example[:string])
      end
    {% end %}

    {% for example in INVALID_BECH32_ENCODE %}
      it "fails to encode '{{example[:string].id}}'" do
        expect_raises(Bech32::Exception, {{example[:exception]}}) do
          Bech32.encode({{example[:prefix]}}, {{example[:words]}})
        end
      end
    {% end %}

    {% for example in VALID_BECH32M %}
      it "encodes string with prefix '{{example[:prefix].id}}' using Bech32M" do
        example = {{example}}
        encoding = Bech32::Encoding::Bech32M

        if limit = example[:limit]?
          string = Bech32.encode(example[:prefix], example[:words], limit, encoding)
        else
          string = Bech32.encode(example[:prefix], example[:words], encoding: encoding)
        end

        string.should eq(example[:string])
      end
    {% end %}

    {% for example in INVALID_BECH32M_ENCODE %}
      it "fails to encode '{{example[:string].id}}' using Bech32M" do
        expect_raises(Bech32::Exception, {{example[:exception]}}) do
          encoding = Bech32::Encoding::Bech32M
          Bech32.encode({{example[:prefix]}}, {{example[:words]}}, encoding: encoding)
        end
      end
    {% end %}

    it "raises with an invalid prefix" do
      example = INVALID_BECH32_ENCODE.find! { |e| e[:exception] == "Invalid prefix" }

      expect_raises(Bech32::PrefixException, "Invalid prefix 'abcÿ'") do
        Bech32.encode(example[:prefix], example[:words])
      end
    end

    it "encodes the docs example" do
      words = Bech32.to_words("foobar".to_slice)
      Bech32.encode("foo", words).should eq("foo1vehk7cnpwgry9h96")
    end

    it "encodes the docs example using Bech32M" do
      words = Bech32.to_words("foobar".to_slice)
      Bech32.encode("foo", words, encoding: Bech32::Encoding::Bech32M)
        .should eq("foo1vehk7cnpwgkc4mqc")
    end
  end
end

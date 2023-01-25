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
        expect_raises(Bech32::Exception, {{example[:excpetion]}}) do
          Bech32.encode({{example[:prefix]}}, {{example[:words]}})
        end
      end
    {% end %}

    {% for example in VALID_BECH32M %}
      it "encodes string with prefix '{{example[:prefix].id}}'" do
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
      it "fails to encode '{{example[:string].id}}'" do
        expect_raises(Bech32::Exception, {{example[:excpetion]}}) do
          encoding = Bech32::Encoding::Bech32M
          Bech32.encode({{example[:prefix]}}, {{example[:words]}}, encoding: encoding)
        end
      end
    {% end %}
  end
end

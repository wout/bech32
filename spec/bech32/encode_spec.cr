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
  end
end

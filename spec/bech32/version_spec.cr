require "yaml"
require "../spec_helper"

describe Bech32::VERSION do
  describe "shard.yml" do
    it "matches the current version" do
      info = YAML.parse(File.read("./shard.yml"))

      Bech32::VERSION.should eq(info["version"])
    end
  end
end

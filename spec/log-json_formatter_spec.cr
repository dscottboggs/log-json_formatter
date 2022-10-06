require "json"
require "./spec_helper"

describe Log::JSONFormatter do
  it "works" do
    reader, writer = IO.pipe
    log = ::Log.for "testing.purposes"
    ::Log.setup sources: "testing.purposes",
      level: :trace,
      backend: Log::IOBackend.new writer,
        formatter: Log::JSONFormatter,
        dispatcher: :sync
    log.info &.emit "test", value: 1
    entry = JSON.parse reader.gets.not_nil!
    entry["severity"].should eq "info"
    entry["message"].as_s.should eq "test"
    entry["data"]["value"].as_i.should eq 1
  end
end

record CustomType, a = 1, b = 2 do
  include ::Log::JSONFormatter::Loggable

  def_to_metadata_value({a: @a, b: @b})
end

describe Log::JSONFormatter::Loggable do
  it "macro works" do
    CustomType.new.to_metadata_value["a"].should eq 1
  end
end

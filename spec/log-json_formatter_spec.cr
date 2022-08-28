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

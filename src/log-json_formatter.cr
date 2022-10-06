require "json"
require "log"

# A `Log::Formatter` for passing NDJSON data to an IO.
class ::Log
  class Metadata
    def to_json(builder : JSON::Builder)
      builder.object do
        each do |key, value|
          builder.field key, value
        end
      end
    end
  end

  struct Metadata::Value
    def to_json(builder : JSON::Builder)
      @raw.to_json builder
    end

    def self.new(value : JSONFormatter::Loggable)
      value.to self.class
    end
  end

  module JSONFormatter
    include Formatter
    extend self

    def format(entry, io)
      JSON.build io do |json|
        json.object do
          {% for field in %w[context data message severity source timestamp] %}
          json.field {{field}} do
            entry.{{field.id}}.to_json json
          end
          {% end %}
          json.field "exception" do
            build_exception json, entry.exception
          end
        end
      end
      io.puts
    end

    def build_exception(builder, exception : Nil)
      builder.null
    end

    def build_exception(builder, exception : Exception)
      builder.object do
        builder.field "message", exception.message
        builder.field "backtrace", exception.backtrace?
        builder.field "cause" do
          build_exception builder, exception.cause
        end
      end
    end

    module Loggable
      abstract def to_metadata_value : ::Log::Metadata::Value

      macro def_to_metadata_value(expr)
        def to_metadata_value : ::Log::Metadata::Value
          ::Log::Metadata::Value.new({{expr}})
        end
      end
    end
  end
end

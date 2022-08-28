# log-json_formatter
A `Log::Formatter` for JSON-encoded logs to an IO

## Installation

1. Add the dependency to your `shard.yml`:

   ```yaml
   dependencies:
     log-json_formatter:
       github: dscottboggs/log-json_formatter
   ```

2. Run `shards install`

## Usage

```crystal
require "log-json_formatter"

record CustomType, a = 1, b = 2 do
  include ::Log::JSONFormatter::Loggable

  def to(cls : ::Log::Metadata::Value) : ::Log::Metadata::Value
    ::Log::Metadata::Value.new({a: @a, b: @b})
  end
end

::Log.setup level: :trace,
            backend: Log::IOBackend.new formatter: Log::JSONFormatter,

Log.info &.emit "example message", metadata: 1, values: %w[of any kind],
  "even values of a": CustomType.new
```

## Contributing

1. Fork it (<https://github.com/dscottboggs/log-json_formatter/fork>)
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

## Contributors

- [D. Scott Boggs](https://github.com/dscottboggs) - creator and maintainer

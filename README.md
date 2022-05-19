# RSpec instrumentation

RSpec instrumentation component to measure performances, profile and monitor the test suite using an external service.

> DISCLAIMER: this is an initial version, major changes will probably happens in the first releases

Support for:
- New Relic
- Sentry APM (partial for now)

Setup the gem, execute the test suite, check the results in the service interface.

## Install

- Add to the Gemfile (in the test group): `gem 'rspec-instrumentation'`
- Follow the specific instructions below per service

### New Relic

- Configure New Relic on your application (also adding the gem 'newrelic_rpm' to the Gemfile)
- Add an initializer in your app (_config/initializers/new_relic.rb_) with:

```rb
RSpecInstrumentation::NewRelic.setup if Rails.env.test?
```

- Add to your _rails_helper.rb_ (or _spec_helper.rb_):

```rb
# It's better to put in at the end, after the other configuration options
RSpec.configure do |config|
  RSpecInstrumentation::RSpec.setup(config, service: :new_relic)
end
```

- If you are using VCR, depending on your configuration you could need also to permit external requests to the New Relic service, example:

```rb
VCR.configure do |config|
  config.ignore_hosts 'collector-001.eu01.nr-data.net' # the host could be different for your account
end
```

## Do you like it? Star it!

If you use this component just star it. A developer is more motivated to improve a project when there is some interest.

Or consider offering me a coffee, it's a small thing but it is greatly appreciated: [about me](https://www.blocknot.es/about-me).

## Contributors

- [Mattia Roccoberton](https://www.blocknot.es): author

## License

The gem is available as open-source under the terms of the [MIT](LICENSE.txt).

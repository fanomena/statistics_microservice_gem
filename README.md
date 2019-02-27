# StatisticsClient
Run `bin/console` for an interactive shell session.

# Configuration
The gem should work by itself out of the box but will allow for additional configuration through the normal initializer configuration flow.

```ruby
StatisticsClient.configure do |config|
  config.api_key            = 'my-api-key'              # Required
  config.api_url            = 'some-url'                # Allows overwriting microservice target URL for development purposes
  config.cookie_id          = 'cookie-key-value'        # The ID used used for the cookie containing the session id
  config.session_expiration = 1.hour                    # Time for session to expire
  config.token_generator    = -> { SecureRandom.uuid }  # Mechanism to use for generating cookie id
end
```

# Usage
The gem is automatically initialized in Rails controllers and views by injecting itself into the helper methods.

```ruby
def index
  tracker.track({
    name: "CLICK_COUPON",
    cool: "very",
    is_optin: true
  })
end
```

The gem only exposes one method for tracking which takes a hash of the event that is being tracked. The event data is arbitrary and can be created during runtime if needed. There's a fixed list of primary attributes that may be passed within the hash that allows for relational data aggregation.

| Attribute        | Required | Default          | Description                                                                                                  |
|------------------|----------|------------------|--------------------------------------------------------------------------------------------------------------|
| name             | Yes      |                  | Used to distinguish different events from each other. Examples: "CLICK_COUPON", "CLICK_CTA", "OPEN_BAG" etc. |
| happened_at      | No       | Current datetime | Timestamp when the event occured.                                                                            |
| event_id         | No       |                  | Foreign key to an Eventbaxx event.                                                                           |
| participation_id | No       |                  | Foreign key to an Eventbaxx participation.                                                                   |
| lead_id          | No       |                  | Foreign key to a Hileadzz lead.                                                                              |

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'statistics_client'
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/statistics_client.

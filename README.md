# StatisticsClient
This gem is a wrapper around the the Fanomena Statistics Microservice.
The gem aims to make it easy for other Fanomena applications to insert and consume data from the microservice.
Internally it uses the Github GraphQL Ruby client gem to format the requests into valid GraphQL queries.

Run `bin/console` for an interactive shell session.

# Configuration
The gem can be configured through the normal initializer configuration flow. Only the `api_key` needs to be set for the tracker to work.

```ruby
StatisticsClient.configure do |config|
  config.master_api_key     = ENV['MASTER_STATISTIXX_KEY']           # Required - Key used for authentication when generating API keys
  config.api_url            = 'some-url'                             # Required - Allows overwriting microservice target URL for development purposes
  config.cookie_id          = 'cookie-key-value'                     # The ID used used for the cookie containing the session id
  config.session_expiration = 1.hour                                 # Time for session to expire
  config.token_generator    = -> { SecureRandom.uuid }               # Mechanism to use for generating session id
  config.origin             = 'EVENTBAXX'                            # Automatically sets ORIGIN
end
```

# Local development
To develop on the gem locally while testing changes in an app it's possible to override bundler's local gem path to specify that you want to use a local gem over the one defined on Github.
To do so run the following command in your console.

```bash
bundle config local.statistics_client /path/to/gem
```

# Usage
## Generating API keys
In order to generate an API key for an organization you must call the following method.
It will return the key. Only one key can exist for an organization at any given time.
```ruby
StatisticsClient::ApiKey.generate(organization_id)
```

## Tracking
A standard tracker object can be initialized within any Ruby code as long as the configuration parameters have been correctly set.

```ruby
tracker = StatisticsClient::Tracker.new
tracker.track({
  name: "MY_EVENT"
})
```

### In controllers
The gem is automatically initialized in Rails controllers by injecting itself into the helper methods.

```ruby
def index
  # Your code ...

  tracker.track({
    name: "CLICK_COUPON",
    origin: "EVENTBAXX",
    cool: "very",
    is_optin: true
  })
end
```

The gem only exposes one method for tracking which takes a hash of the event that is being tracked. The event data is arbitrary and can be created during runtime if needed. There's a fixed list of primary attributes that may be passed within the hash that allows for relational data aggregation.

| Attribute                 | Required | Default          | Description                                                                                                  |
|---------------------------|----------|------------------|--------------------------------------------------------------------------------------------------------------|
| name                      | Yes      |                  | Used to distinguish different events from each other. Examples: "CLICK_COUPON", "CLICK_CTA", "OPEN_BAG" etc. |
| origin                    | Yes      |                  | Origin of the tracking. Examples: "EVENTBAXX", "HILEADZZ"                                                    |
| eventbaxx_organization_id | No       |                  | Foreign key to an Eventbaxx organization. Either this or Hileadzz MUST be set!                               |
| hileadzz_organization_id  | No       |                  | Foreign key to a Hileadzz organization. Either this or Eventbaxx MUST be set!                                |
| happened_at               | No       | Current datetime | Timestamp when the event occured.                                                                            |
| event_id                  | No       |                  | Foreign key to an Eventbaxx event.                                                                           |
| participation_id          | No       |                  | Foreign key to an Eventbaxx participation.                                                                   |
| lead_id                   | No       |                  | Foreign key to a Hileadzz lead.                                                                              |

### In JavaScript
As it's not possible to call Rails controller methods directly from JavaScript because of the frontend/backend separation you will need to use AJAX to call a [predefined controller action](#usage-in-controllers). In JavaScript it is possible to log quite a few more important user details that are recommended to be included in the request.

```javascript
// Track data in our own microservice.
// We have to wait some time to generate the fingerprint since some used attributes take time to load (if user has just loaded Eventbaxx)
setTimeout((function() {
  Fingerprint2.get(function(components) {
    var fingerprint, values;
    values = components.map(function(component) {
      return component.value;
    });
    fingerprint = Fingerprint2.x64hash128(values.join(''), 31);
    $.ajax({
      url: '/trackings/microservice',
      type: 'POST',
      async: true,
      data: {
        advertisement_id: advertisement_id,
        participation_id: participation_id,
        name: event_name,
        event_id: event_id,
        device_width: document.documentElement.clientWidth,
        device_height: document.documentElement.clientHeight,
        origin: 'EVENTBAXX',
        fingerprint: fingerprint
      }
    });
  });
}), 50);
```

In order to generate the fingerprint it's recommended to use [Fingerprint2js](https://github.com/Valve/fingerprintjs2).

| Attribute        | Required | Default          | Description                                                                                                  |
|------------------|----------|------------------|--------------------------------------------------------------------------------------------------------------|
| name             | Yes      |                  | Used to distinguish different events from each other. Examples: "CLICK_COUPON", "CLICK_CTA", "OPEN_BAG" etc. |
| origin           | Yes      |                  | Origin of the tracking. Examples: "EVENTBAXX", "HILEADZZ"                                                    |
| fingerprint      | No       |                  | Unique fingerprint of user. While not required it is strongly recommended to use!                            |
| happened_at      | No       | Current datetime | Timestamp when the event occured.                                                                            |
| event_id         | No       |                  | Foreign key to an Eventbaxx event.                                                                           |
| participation_id | No       |                  | Foreign key to an Eventbaxx participation.                                                                   |
| lead_id          | No       |                  | Foreign key to a Hileadzz lead.                                                                              |
| device_width     | No       |                  | Width of current device                                                                                      |
| device_height    | No       |                  | Height of current device                                                                                     |

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

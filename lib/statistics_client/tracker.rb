module StatisticsClient
  class Tracker

    def initialize(**args)
      @controller = args[:controller]
      @cookies    = args[:cookies]
      @request    = args[:request] || @controller.try(:request)
    end

    def track(data)
      validate_api_key_set
      data        = HashWithIndifferentAccess.new(data)
      parsed_data = Parser.parse(data, @request)

      # Set id of session either from cookie or generate one
      cookie_name = config.cookie_id
      if @cookies[cookie_name]
        parsed_data[:session_id] = @cookies[cookie_name]
      else
        token                    = generate_token
        parsed_data[:session_id] = token
        set_cookie(cookie_name, token)
      end

      # Set happened_at and send parsed event data to microservice
      parsed_data[:happened_at] ||= DateTime.now
      post_data(parsed_data)
    end

  private

    def set_cookie(cookie_name, token)
      cookie = {
        value: token,
        expires: config.session_expiration.from_now,
        domain: @request.domain
      }
      @request.cookie_jar[cookie_name] = cookie
    end

    def post_data(data)
      Client.post("events", data)
    end

    def validate_api_key_set
      if config.nil? || config.api_key.nil?
        raise StandardError, "API key must be set before you can start tracking"
      end
    end

    def generate_token
      config.token_generator.call
    end

    def config
      StatisticsClient.configuration
    end
  end
end
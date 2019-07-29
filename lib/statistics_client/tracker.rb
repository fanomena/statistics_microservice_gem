require 'uri'

module StatisticsClient
  class Tracker

    def initialize(**args)
      @controller = args[:controller]
      @cookies    = args[:cookies]
      @request    = args[:request] || @controller.try(:request)
    end
    
    # Entry point for tracking data to the microservice.
    # Validate, parse, and transform data into format that is required
    # by the microservice.
    def track(data)
      data          = HashWithIndifferentAccess.new(data)
      data[:origin] = config.origin unless data[:origin]
      parsed_data   = Parser.parse(data, @request)

      # Set id of session either from cookie or generate one
      cookie_name = config.cookie_id
      if @cookies && @cookies[cookie_name]
        parsed_data[:session_id] = @cookies[cookie_name]
      else
        token                    = generate_token
        parsed_data[:session_id] = token
        set_cookie(cookie_name, token) if @cookies
      end

      # Set happened_at and send parsed event data to microservice
      parsed_data[:happened_at] ||= DateTime.now
      post_data(parsed_data)
    end

    private

      def set_cookie(cookie_name, token)
        domain = defined?(@request.domain) && @request.domain ? @request.domain : URI.parse(@request.headers['Origin']).host

        if defined?(@request.cookie_jar)
          @request.cookie_jar[cookie_name] = @cookie
        else
          @request.cookies[cookie_name] = @cookie
        end
      end

      # Use CREATE_EVENT mutation to perform a mutation on the microservice
      def post_data(data)
        mutation = Mutations::CREATE_EVENT
        Client.query(mutation, {
          "sessionId": data[:session_id],
          "eventInput": {
            "input": data
          }
        })
      end

      def generate_token
        config.token_generator.call
      end

      def config
        StatisticsClient.configuration
      end
    end
end

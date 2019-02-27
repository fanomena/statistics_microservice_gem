require 'byebug'

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
      # Set happened_at if not set directly in data argument
      byebug
    end

  private

    def send_microservice(visit)
      Client.post("/visits",visit.to_h)
    end

    def validate_api_key_set
      if StatisticsClient.configuration.nil? || StatisticsClient.configuration.api_key.nil?
        raise StandardError, "API key must be set before you can start tracking"
      end
    end
  end
end
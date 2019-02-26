module StatisticsClient
  module Parser
    def self.parse(data)
      # Implement parser
      valid = Validator.validate?(data)

      # Uppercase event name
      # Convert all non-standard fields into tracking_data value (fits with microservice database schema)
      # Parse headers
      # IP lookup
      return data
    end

    def get_geo_location(ip)
      @ip = Geocoder.search(ip).first
    end

    def browser_info
      # get referrer info from request
      # get user agent from browser for
      # @user_agent = UserAgentParser.parse(request.user_agent)
      # @browser = user_agent.family
    end
  end
end
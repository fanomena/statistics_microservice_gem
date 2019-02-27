require 'httparty'

module StatisticsClient
  class Client

    def self.get(path, data={})
      send(path, :get, data)
    end

    def self.post(path, data)
      send(path, :post, data)
    end

    private

      def self.send(path, method, data)
        url    = "#{api_url}/#{path}"
        result = HTTParty.send(method.to_s, url, headers: headers, query: data)
        result.parsed_response
      end

      def self.headers
        {
          'Content-Type' => "application/json",
          'Authorization' => config.api_key
        }
      end

      def self.api_url
        config.api_url
      end

      def self.config
        StatisticsClient.configuration
      end
  end
end

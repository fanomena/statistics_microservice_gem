require 'httparty'
module StatisticsClient
  class Client

    def self.get(path, params={})
      send(path, :get, params)
    end

    def self.post(path, params)
      send(path, :post, params)
    end

    private

      def self.send(path, method, params)
        url    = "#{api_url}/#{path}"
        result = HTTParty.send(method.to_s, url, headers: headers, query: params)
        result.parsed_response
      end

      def self.headers
        {
          'Content-Type' => "application/json"
        }
      end

      def self.api_url
        StatisticsClient.configuration.api_url
      end
  end
end

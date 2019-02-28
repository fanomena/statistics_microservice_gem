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
        result = nil
        data   = data.to_json
        if method == :post || method == :patch
          result = HTTParty.send(method.to_s, url, headers: headers, body: data)
        else
          result = HTTParty.send(method.to_s, url, headers: headers, query: data)
        end
        result.parsed_response
      rescue StandardError
        # Request didn't make it to service
        false
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

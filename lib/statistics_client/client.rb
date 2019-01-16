require 'httparty'
module StatisticsClient
  class Client

    def self.get(path, params={})
      send("#{api_url}/#{path}", :get, params)
    end

    def self.post(path, params)
      send("#{api_url}/#{path}", :post, params)
    end

    private

      def self.send(url, method, params)
        puts "#{method} #{params}"
        result = HTTParty.send(method.to_s, url, headers: headers, query: params)
        result.parsed_response
      end

      def self.headers
        {
          'Content-Type' => "application/json"
        }
      end

      def self.api_url
        StatisticsClient.api_url
      end
  end
end

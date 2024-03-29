# Handle all outbound HTTP actions to the microservice API
module StatisticsClient
  class Client
    QueryError = Class.new(StandardError)

    class << self
      attr_accessor :client
    end

    # definition - Mutation or Query from ::Mutations or ::Queries
    #
    # Returns a structured query result or raises if the request failed.
    def self.query(definition, api_key, variables = {})
      if !api_key
        raise QueryError.new('No API key specified!')
      end

      response = self.client.query(definition, variables: variables, context: client_context(api_key))

      if response.errors.any?
        raise QueryError.new(response.errors[:data].join(", "))
      else
        data = response.data.to_h
        data = data.transform_keys {|k| k.underscore} if defined?(Rails)
        data = HashWithIndifferentAccess.new(data) if defined?(Rails)
        data
      end
    end

    # Configures the GraphQL client used to query the microservice.
    # This NEEDS to be run AFTER the configuration is correctly setup for StatisticsClient
    # as it needs to use the configuration to fetch the correct api_url.
    def self.configure_client
      http = GraphQL::Client::HTTP.new("#{StatisticsClient.configuration.api_url}/graphql") do
        def headers(context)
          {
            'Content-Type' => "application/json",
            'Authorization' => context[:api_key]
          }
        end
      end
      # Fetch latest schema on init, this will make a network request
      begin
        schema = GraphQL::Client.load_schema(http)
      rescue Exception => e
        # No connection can be made
        self.client = nil
        return nil
      end
      # TODO: Dump schema
      # However, it's smart to dump this to a JSON file and load from disk
      #
      # Run it from a script or rake task
      #   GraphQL::Client.dump_schema(SWAPI::HTTP, "path/to/schema.json")
      #
      # Schema = GraphQL::Client.load_schema("path/to/schema.json")
      
      self.client = GraphQL::Client.new(schema: schema, execute: http)
      return self.client
    end

    def self.client_context(api_key)
      {
        api_key: api_key
      }
    end
  end
end

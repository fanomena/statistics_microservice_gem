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
    def self.query(definition, variables = {})
      response = self.client.query(definition, variables: variables, context: client_context)

      if response.errors.any?
        raise QueryError.new(response.errors[:data].join(", "))
      else
        response.data
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
            'Authorization' => StatisticsClient.configuration.api_key
          }
        end
      end
      # Fetch latest schema on init, this will make a network request
      schema = GraphQL::Client.load_schema(http)
      # TODO: Dump schema
      # However, it's smart to dump this to a JSON file and load from disk
      #
      # Run it from a script or rake task
      #   GraphQL::Client.dump_schema(SWAPI::HTTP, "path/to/schema.json")
      #
      # Schema = GraphQL::Client.load_schema("path/to/schema.json")
      
      self.client = GraphQL::Client.new(schema: schema, execute: http)
    end

    def self.client_context
      {
        'Content-Type' => "application/json",
        'Authorization' => StatisticsClient.configuration.api_key
      }
    end
  end
end

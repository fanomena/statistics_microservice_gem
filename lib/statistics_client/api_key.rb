module StatisticsClient
  class ApiKey
    # Generate an API key for the given organization id
    def self.generate(organization_id)
      mutation = Mutations::GENERATE_API_KEY
      api_key  = config.master_api_key
      Client.query(mutation, api_key, {
        organizationId: organization_id
      })
    end

    private

      def self.config
        StatisticsClient.configuration
      end
  end
end

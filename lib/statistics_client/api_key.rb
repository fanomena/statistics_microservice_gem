module StatisticsClient
  class ApiKey
    # Generate an API key for the given organization id
    def self.generate(organization_id)
      api_key = ENV['STATISTIXX_MASTER_KEY']
      mutation = Mutations::GENERATE_API_KEY
      Client.query(mutation, api_key, {
        organizationId: organization_id
      })
    end
  end
end

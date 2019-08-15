class Mutations
  # Create an event
  CREATE_EVENT = StatisticsClient::Client.client.parse <<-'GRAPHQL'
    mutation($sessionId: UUID!, $eventInput: EventInput!) {
      createEvent(sessionId: $sessionId, input: $eventInput) {
        name
        happened_at
      }
    }
  GRAPHQL

  # Generate an API key
  GENERATE_API_KEY = StatisticsClient::Client.client.parse <<-'GRAPHQL'
    mutation(
      $organizationId: Int!
    ) {
      generateKey(organizationId: $organizationId) {
        key
        origin
        organization_id
      }
    }
  GRAPHQL
end

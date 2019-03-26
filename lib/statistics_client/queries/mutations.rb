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
end

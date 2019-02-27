module StatisticsClient
  class Event < ::Entity
    MEMBER_VARIABLES = [
      :name, :happened_at, :tracking_data
    ]

    MEMBER_VARIABLES.each do |a|
      attr_accessor a
    end

    def self.find(id)
      # Todo
      #return from_hash(Client.get("visits/#{id}"))
    end
  end
end

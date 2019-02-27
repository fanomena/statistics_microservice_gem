module StatisticsClient
  class Session < ::Entity
    MEMBER_VARIABLES = [
      :participation_id, :event_id, :lead_id, :city, :region,
      :user_agent, :device_type, :screen_height, :screen_width, :browser,
      :created_at, :updated_at, :referrer, :latitude, :longitude
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

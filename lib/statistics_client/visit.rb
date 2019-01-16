module StatisticsClient
  class Visit < ::Entity
    MEMBER_VARIABLES = [:id, :browser, :created_at, :updated_at, :referrer,
    :ip, :visitor_id]

    MEMBER_VARIABLES.each do |a|
      attr_accessor a
    end

    def self.find(id)
      return from_hash(Client.get("visits/#{id}"))
    end
  end
end

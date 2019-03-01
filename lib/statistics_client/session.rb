module StatisticsClient
  class Session < ::Entity
    MEMBER_VARIABLES = [
      :participation_id, :event_id, :lead_id, :city, :region, :ip, :os,
      :user_agent, :device_type, :device_name, :device_height, :device_width,
      :browser, :created_at, :updated_at, :referrer, :latitude, :longitude
    ]

    MEMBER_VARIABLES.each do |a|
      attr_accessor a
    end
  end
end

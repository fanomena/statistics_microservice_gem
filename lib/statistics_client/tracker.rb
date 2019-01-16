module StatisticsClient
  class Tracker

    require 'user_agent_parser'
    require 'byebug'

    attr_reader :cookies
    def initialize
      @current_visit = nil
      @cookies = {'visit_event_1': 1}
    end

    def track_visit(event_id, participation_id, request)
      byebug
      # Is the visit new or old?
      # Look for visit in cookie
      if !cookies["visit_#{event_id}".to_sym].nil?
        # If found
        # @current_visit = found_visit
        # Update visit with new last_seen
        # Send visit to microservice
        current_visit = StatisticsClient::Visit.find(cookies["visit_#{event_id}".to_sym])
      else
        # If not Found
        # Create new visit
        # Track with headers/geocoder/whatever black magic
        # @current_visit = new_visit
        # Send visit to microservice
        # cookies["visit_#{id}"] = Visit.create(id: @event.id)
        # # salted_part_id = salt(id)
        visit = StatisticsClient::Visit.new
        # visit.browser    = request.user_agent
        # visit.referrer   = request.referrer
        # visit.ip         = get_geo_locations(request.remote_ip)
        visit.visitor_id = participation_id
        send_microservice(visit)
      end
    end

  private
    def track(event)
      # Create Event for @current_visit
      # Send to microservice
    end

    def get_geo_location(ip)
      @ip = Geocoder.search(ip).first
    end

    def send_microservice(visit)
      Client.post("/visits",visit.to_h)
    end

    def browser_info
      # get referrer info from request
      # get user agent from browser for
      @user_agent = UserAgentParser.parse(request.user_agent)
      @browser = user_agent.family
    end
  end
end

class StatisticsClient::Tracker

    #require 'user_agent_parser'
    attr_reader :cookies
    def initialize
      @current_visit = nil
      @cookies = {'visit_event_1': 1}
    end

    def track_visit(id)
      # Is the visit new or old?
      # Look for visit in cookie
      if !cookies["visit_#{id}".to_sym].nil?
        # If found
        # @current_visit = found_visit
        # Update visit with new last_seen
        # Send visit to microservice
        current_visit = Visit.find(cookies["visit_#{id}".to_sym])
      else
        # If not Found
        # Create new visit
        # Track with headers/geocoder/whatever black magic
        # @current_visit = new_visit
        # Send visit to microservice
        # cookies["visit_#{id}"] = Visit.create(id: @event.id)
        # # salted_part_id = salt(id)
        # visit = Visit.find(@event.id)
        # visit.browser = browser_info
        # visit.ip = get_geo_locations(request.remote_ip)
        # send_microservice
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

    def send_microservice

    end

    def browser_info
      # get referrer info from request
      # get user agent from browser for
      @user_agent = UserAgentParser.parse(request.user_agent)
      @browser = user_agent.family
    end
end

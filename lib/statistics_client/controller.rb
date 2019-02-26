module StatisticsClient
  module Controller
    def included(base)
      if base.respond_to?(:helper_method)
        base.helper_method :tracker
      end
    end

    def tracker
      @tracker ||= StatisticsClient::Tracker.new(controller: self, request: self.request, cookies: cookies)
    end
  end
end
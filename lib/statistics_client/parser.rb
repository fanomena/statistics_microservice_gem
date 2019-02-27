require 'geocoder'
require 'user_agent_parser'
require 'device_detector'

module StatisticsClient
  module Parser

    # Parse incoming data and request into useful statistical data
    def self.parse(data, request)
      raise StandardError, "Data is invalid" unless Validator.new(data).valid?
      data[:name] = normalize_event_name(data[:name])

      # IP/Region/City data - We delete IP due to GDPR
      if data[:ip]
        data.merge(lookup_ip(data[:ip]))
        data[:ip] = mask_ip(data[:ip])
      end

      # Parse user agent into usable device information
      if request.user_agent
        data.merge(parse_user_agent(request.user_agent))
      end

      # Set referer header if present
      data[:referer] = request.referer if request.referer

      # Gather utm data
      if request.original_url
        data.merge(utm_properties(request.original_url, request.params))
      end

      # Convert all non-standard fields into tracking_data value
      data[:tracking_data] ||= {}
      data.each do |key, value|
        if !Session::MEMBER_VARIABLES.include?(key.to_sym) && !Event::MEMBER_VARIABLES.include?(key.to_sym)
          data[:tracking_data][key] = value
          data.delete(key)
        end
      end
      return data
    end

    private

      def self.lookup_ip(ip)
        geo_data = Geocoder.search(ip).first
        {
          region: geo_data.region,
          city: geo_data.city
        }
      end

      def self.normalize_event_name(name)
        name.strip.gsub(/ /, '_').upcase
      end

      def self.parse_user_agent(user_agent)
        agent   = DeviceDetector.new(user_agent)
        browser = Browser.new(user_agent)
        device_type =
                  if browser.bot?
                    "Bot"
                  elsif browser.device.tv?
                    "TV"
                  elsif browser.device.console?
                    "Console"
                  elsif browser.device.tablet?
                    "Tablet"
                  elsif browser.device.mobile?
                    "Mobile"
                  else
                    "Desktop"
                  end
        {
          browser: agent.name,
          os: agent.os_name,
          device_type: device_type,
          device_name: agent.device_name
        }
      end

      # Gather utm properties from URL
      def self.utm_properties(url, params)
        landing_uri = Addressable::URI.parse(url) rescue nil
        landing_params = (landing_uri && landing_uri.query_values) || {}

        props = {}
        %w(utm_source utm_medium utm_term utm_content utm_campaign).each do |name|
          props[name.to_sym] = params[name] || landing_params[name]
        end
        props
      end

      # Mask an IP according to the Google specification:
      # https://support.google.com/analytics/answer/2763052
      def self.mask_ip(ip)
        addr = IPAddr.new(ip)
        if addr.ipv4?
          # set last octet to 0
          addr.mask(24).to_s
        else
          # set last 80 bits to zeros
          addr.mask(48).to_s
        end
      end
  end
end
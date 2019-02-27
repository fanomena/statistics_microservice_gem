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
        geodata       = lookup_ip(data[:ip])
        data[:ip]     = mask_ip(data[:ip])
        data[:region] = geodata.region
        data[:city]   = geodata.city
      end

      # Parse user agent into usable device information
      if request.user_agent
        user_agent_data    = parse_user_agent(request.user_agent)
        data[:browser]     = user_agent_data[:browser]
        data[:os]          = user_agent_data[:os]
        data[:device_type] = user_agent_data[:device_type]
        data[:device_name] = user_agent_data[:device_name]
      end

      # Set referer header if present
      data[:referer] = request.referer if request.referer

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
        Geocoder.search(ip).first
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
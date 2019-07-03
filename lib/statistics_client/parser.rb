require 'geocoder'
require 'user_agent_parser'
require 'device_detector'

module StatisticsClient
  module Parser

    # Parse incoming data and request into useful statistical data
    def self.parse(data, request)
      Validator.new(data).valid?

      # Nothing to parse if request is not present
      return data unless request
      data = sanitize_data(data, request)

      # IP/Region/City data
      data.merge!(lookup_ip(data[:ip])) if data[:ip]

      # Parse user agent into usable device information
      data.merge!(parse_user_agent(request.user_agent)) if request.user_agent

      # Set referer header if present
      data[:referrer] = request.referer if request.referer

      # Gather utm data
      data.merge!(utm_properties(request.original_url, request.params)) if request.original_url

      return data
    end

    private

      def self.sanitize_data(data, request)
        data[:name] = normalize_event_name(data[:name])
        data[:ip]   = 
                  if defined?(request.remote_ip)
                    mask_ip(request.remote_ip)
                  else
                    mask_ip(request.ip)
                  end
        data
      end

      def self.lookup_ip(ip)
        geo_data = Geocoder.search(ip).first
        if geo_data
          return {
            region: geo_data.region,
            city: geo_data.city
          }
        else
          return {}
        end
      end

      def self.normalize_event_name(name)
        name.strip.gsub(/ /, '_').upcase
      end

      def self.parse_user_agent(user_agent)
        agent       = DeviceDetector.new(user_agent)
        browser     = Browser.new(user_agent)
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
          user_agent: user_agent,
          browser: agent.name,
          os: agent.os_name,
          device_type: device_type,
          device_name: agent.device_name
        }
      end

      # Gather utm properties from URL
      def self.utm_properties(url, params)
        landing_uri    = Addressable::URI.parse(url) rescue nil
        landing_params = (landing_uri && landing_uri.query_values) || {}

        props = {}
        %w(utm_source utm_medium utm_term utm_content utm_campaign).each do |name|
          value              = params[name] || landing_params[name]
          props[name.to_sym] = value if value
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

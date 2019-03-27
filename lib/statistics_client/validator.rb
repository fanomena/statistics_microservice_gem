# Validate that data is correctly formatted and contains correct values.
# Raise a custom error if invalid so that a consumer of the gem can easily
# understand that it's a validation error
module StatisticsClient
  class Validator
    class ValidationError < StandardError; end

    def initialize(data)
      @data = data
    end

    def valid?
      validate_api_key_set
      validate_api_url_set
      validate_origin_set
      validate_name_is_set
      true
    end

    private

      def validate_name_is_set
        raise ValidationError.new("Required name variable is not present in tracking data") unless @data.has_key?(:name) && @data[:name]
      end

      def validate_origin_set
        raise ValidationError.new("Origin must be set before you can start tracking") if @data[:origin].nil? || @data[:origin].empty?
      end

      def validate_api_url_set
        raise ValidationError.new("API URL must be set before you can start tracking") if config.nil? || config.api_url.nil?
      end

      def validate_api_key_set
        raise ValidationError.new("API key must be set before you can start tracking") if config.nil? || config.api_key.nil?
      end

      def config
        StatisticsClient.configuration
      end
  end
end

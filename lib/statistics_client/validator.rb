module StatisticsClient
  class Validator
    def initialize(data)
      @data = data
    end

    def valid?
      validate_name_is_set
      return true
    end

    private

      def validate_name_is_set
        raise StatisticsClient::Error, "Required name variable is not present in tracking data" unless @data.has_key?(:name) && @data[:name]
      end
  end
end
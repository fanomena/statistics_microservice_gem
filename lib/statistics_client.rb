require "active_support"
require "active_support/core_ext"
require "configuration"
require "statistics_client/parser"
require "statistics_client/validator"
require "statistics_client/controller"
require "statistics_client/entity"
require "statistics_client/version"
require "statistics_client/tracker"
require "statistics_client/visit"
require "statistics_client/client"

module StatisticsClient
  class << self
    attr_accessor :configuration
  end

  def self.configure
    self.configuration ||= Configuration.new
    yield(configuration)
  end
end

ActiveSupport.on_load(:action_controller) do
  include StatisticsClient::Controller
end
require "graphql/client"
require "graphql/client/http"
require "active_support"
require "active_support/core_ext"
require "configuration"
require "statistics_client/api_key"
require "statistics_client/parser"
require "statistics_client/validator"
require "statistics_client/controller"
require "statistics_client/entity"
require "statistics_client/version"
require "statistics_client/tracker"
require "statistics_client/event"
require "statistics_client/session"
require "statistics_client/client"

module StatisticsClient
  class << self
    attr_accessor :configuration
  end

  def self.configure
    self.configuration ||= Configuration.new
    yield(configuration)
    client = Client.configure_client
    if client
      StatisticsClient.require_queries
    end
  end

  def self.require_queries
    # Require all mutations and queries after the client is setup
    Dir[File.dirname(__FILE__) + "/statistics_client/queries/*.rb"].each {|file| require file }
  end
end

# Hook into Rails controllers
ActiveSupport.on_load(:action_controller) do
  include StatisticsClient::Controller
end

require 'byebug'
require "statistics_client/entity"
require "statistics_client/version"
require "statistics_client/tracker"
require "statistics_client/visit"
require "statistics_client/client"

module StatisticsClient

  def self.api_url
    "http://localhost:8000"
  end
  # Your code goes here...
end

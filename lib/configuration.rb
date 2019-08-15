class Configuration
  attr_accessor :api_url, :master_api_key, :cookie_id, :session_expiration, :token_generator, :origin

  def initialize
    @api_url            = "http://localhost:5000"
    @master_api_key     = nil
    @cookie_id          = 'statistics_token'
    @session_expiration = 1.hour
    @token_generator    = -> { SecureRandom.uuid }
    @origin             = nil
  end
end

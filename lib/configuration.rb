class Configuration
  attr_accessor :api_url, :api_key

  def initialize
    @api_url = "http://localhost:8000"
    @api_key = nil
  end
end

lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "statistics_client/version"

Gem::Specification.new do |spec|
  spec.name          = "statistics_client"
  spec.version       = StatisticsClient::VERSION
  spec.authors       = ["Rasmus Reiler"]
  spec.email         = ["rasmus@fanomena.de"]

  spec.summary       = %q{A gem for interacting with the Fanomena statistics service}
  spec.description   = %q{A gem for interacting with the Fanomena statistics service}
  spec.homepage      = ""

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  if spec.respond_to?(:metadata)
    spec.metadata["allowed_push_host"] = "TODO: Set to 'http://mygemserver.com'"
  else
    raise "RubyGems 2.0 or newer is required to protect against " \
      "public gem pushes."
  end

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.16"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_development_dependency "byebug", "~> 10.0.2"
  spec.add_dependency "user_agent_parser"
  spec.add_dependency "geocoder"
  spec.add_dependency "device_detector"
  spec.add_dependency "graphql-client"
  spec.add_dependency "browser"
end

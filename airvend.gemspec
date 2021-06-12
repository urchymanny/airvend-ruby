# frozen_string_literal: true

require_relative "lib/airvend/version"

Gem::Specification.new do |spec|
  spec.name          = "airvend"
  spec.version       = Airvend::VERSION
  spec.authors       = ["Uchenna Mba"]
  spec.email         = ["hey@uche.io"]

  spec.summary       = "Gem that provides access to bill payment & subscription in Nigeria."
  spec.description   = "This gem makes it easy for businesses or individuals to implement vending of Airtime, Data, Electricity, Utilities & Television subscriptions to their application"
  spec.homepage      = "https://github.com/urchymanny/airvend-rails"
  spec.license       = "MIT"
  spec.required_ruby_version = Gem::Requirement.new(">= 2.3.0")

  # spec.metadata["allowed_push_host"] = "TODO: Set to 'http://mygemserver.com'"
  #
  # spec.metadata["homepage_uri"] = spec.homepage
  # spec.metadata["source_code_uri"] = "TODO: Put your gem's public repo URL here."
  # spec.metadata["changelog_uri"] = "TODO: Put your gem's CHANGELOG.md URL here."

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{\A(?:test|spec|features)/}) }
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  # Uncomment to register a new dependency of your gem
  spec.add_development_dependency 'dotenv-rails'
  spec.add_development_dependency 'byebug'
  spec.add_dependency 'httparty', '~> 0.18'
  spec.add_dependency 'json', '~> 2.5'
  spec.add_dependency 'faraday', '~> 1.4'
  spec.add_dependency 'faraday-detailed_logger', '~> 2.3'
  spec.add_dependency 'typhoeus', '~> 1.4'

  # For more information and examples about making a new gem, checkout our
  # guide at: https://bundler.io/guides/creating_gem.html
end

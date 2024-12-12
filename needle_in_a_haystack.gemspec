require_relative "lib/needle_in_a_haystack/version"

Gem::Specification.new do |spec|
  spec.name = "needle_in_a_haystack"
  spec.version = VERSION
  spec.authors = ["Frans Verberne"]
  spec.email = ["frans.verberne@fouriq.nl"]
  spec.homepage = "https://www.fouriq.nl"
  spec.summary = "Models and dependencies shared across our projects."
  spec.description = "haystack ontology implementation for FourIQ projects."
  spec.license = "Nonstandard"
  spec.required_ruby_version = ">= 3.3.0"

  spec.metadata["allowed_push_host"]

  spec.metadata["homepage_uri"] = spec.homepage

  spec.files = Dir[
    "config/locales/**/*",
    "lib/**/*",
    "spec/models/*",
    "spec/strategies/*",
    "Rakefile",
    "README.md",
  ]

  spec.add_dependency "dotenv-rails"
  spec.add_dependency "factory_bot_rails"
  spec.add_dependency "mysql2"
  spec.add_dependency "rails", "~> 7.1"
  spec.add_dependency "rspec-rails"
end

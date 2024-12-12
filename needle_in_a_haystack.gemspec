require_relative "lib/needle_in_a_haystack/version"

Gem::Specification.new do |spec|
  spec.name = "needle_in_a_haystack"
  spec.version = VERSION
  spec.authors = ["Frans Verberne"]
  spec.email = ["frans.verberne@fouriq.nl"]
  spec.homepage = "https://github.com/Fransver/needle_in_a_haystack"
  spec.summary = "haystack ontology implementation for FourIQ projects."
  spec.description = "A Ruby gem for implementing the Haystack ontology, providing a structured way to manage and interact with building and equipment data."
  spec.license = "MIT"
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

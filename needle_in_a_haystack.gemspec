require_relative "lib/needle_in_a_haystack/version"

Gem::Specification.new do |spec|
  spec.name = "needle_in_a_haystack"
  spec.version = NeedleInAHaystack::VERSION
  spec.authors = ["Frans Verberne"]
  spec.email = ["frans.verberne@fouriq.nl"]
  spec.homepage = "https://github.com/Fransver/needle_in_a_haystack"
  spec.summary = "Project Haystack tagging ontology for Rails."
  spec.description = <<~DESC.strip
    A Rails engine that implements the Project Haystack tagging ontology: a
    hierarchical tag tree plus a polymorphic tagging layer for attaching
    semantic tags to any ActiveRecord model. Built for managing building and
    equipment data, but useful for any hierarchical tagging problem.
  DESC
  spec.license = "MIT"
  spec.required_ruby_version = ">= 3.1.0"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = spec.homepage
  spec.metadata["changelog_uri"] = "#{spec.homepage}/blob/master/CHANGELOG.md"
  spec.metadata["bug_tracker_uri"] = "#{spec.homepage}/issues"
  spec.metadata["rubygems_mfa_required"] = "true"

  spec.files = Dir[
    "lib/**/*.rb",
    "lib/tasks/**/*.rake",
    "config/locales/**/*",
    "config/haystack_ontology.yml",
    "db/migrate/**/*",
    "CHANGELOG.md",
    "LICENSE",
    "README.md"
  ]
  spec.require_paths = ["lib"]

  # Runtime dependencies are limited to the slice of Rails the engine actually
  # needs. The database adapter (e.g. mysql2, pg, sqlite3) is left to the host
  # application so the gem stays driver-agnostic.
  spec.add_dependency "activerecord", ">= 7.1"
  spec.add_dependency "activesupport", ">= 7.1"
  spec.add_dependency "railties", ">= 7.1"
end

require "pathname"

require "needle_in_a_haystack/version"
require "needle_in_a_haystack/engine"
require "needle_in_a_haystack/configuration"

require "needle_in_a_haystack/application_record"
require "needle_in_a_haystack/concerns/base_tagging"
require "needle_in_a_haystack/concerns/base_tag"
require "needle_in_a_haystack/concerns/taggable"

require "needle_in_a_haystack/models/haystack_tag"
require "needle_in_a_haystack/models/haystack_tagging"
require "needle_in_a_haystack/models/haystack_ontology"

require "needle_in_a_haystack/factories/base_factory"
require "needle_in_a_haystack/strategies/tag_strategy"
require "needle_in_a_haystack/strategies/default_tag_strategy"
require "needle_in_a_haystack/strategies/ontology_tag_strategy"
require "needle_in_a_haystack/factories/haystack_factory"

require "needle_in_a_haystack/strategies/query_strategy"
require "needle_in_a_haystack/strategies/query_context"
require "needle_in_a_haystack/strategies/find_by_tags_strategy"
require "needle_in_a_haystack/strategies/find_points_with_tag_strategy"
require "needle_in_a_haystack/strategies/find_points_with_multiple_tags_strategy"

# Needle in a Haystack is a Rails engine that implements the
# {Project Haystack}[https://project-haystack.org] tagging ontology: a
# hierarchical tag tree plus a polymorphic tagging layer that lets you attach
# semantic tags to any ActiveRecord model.
module NeedleInAHaystack
  GEM_ROOT = Pathname.new(File.expand_path("..", __dir__)).freeze

  class << self
    attr_writer :configuration

    # The active configuration, memoised. See {Configuration}.
    def configuration
      @configuration ||= Configuration.new
    end

    # Yields the configuration for mutation:
    #
    #   NeedleInAHaystack.configure do |config|
    #     config.ontology_path = Rails.root.join("config/ontology.yml")
    #   end
    def configure
      yield(configuration)
    end

    # Path to the ontology YAML that ships with the gem. Used as the default
    # when the host application does not configure its own.
    def default_ontology_path
      GEM_ROOT.join("config", "haystack_ontology.yml")
    end
  end
end

require "needle_in_a_haystack/version"
require "needle_in_a_haystack/engine"
require "needle_in_a_haystack/application_record"
require "needle_in_a_haystack/configuration"
require "needle_in_a_haystack/concerns/base_tagging"
require "needle_in_a_haystack/concerns/base_tag"
require "needle_in_a_haystack/factories/base_factory"

require "needle_in_a_haystack/models/haystack_ontology"
require "needle_in_a_haystack/concerns/taggable"
require "needle_in_a_haystack/models/haystack_tag"
require "needle_in_a_haystack/models/haystack_tagging"
require "needle_in_a_haystack/factories/haystack_factory"
require "needle_in_a_haystack/strategies/query_context"
require "needle_in_a_haystack/strategies/query_strategy"
require "needle_in_a_haystack/strategies/find_by_tags_strategy"
require "needle_in_a_haystack/strategies/find_point_by_tag_strategy"
require "needle_in_a_haystack/strategies/find_points_with_multiple_tags_strategy"
require "needle_in_a_haystack/strategies/tag_strategy"
require "needle_in_a_haystack/strategies/default_tag_strategy"
require "needle_in_a_haystack/strategies/ontology_tag_strategy"

module NeedleInAHaystack
  class << self
    attr_accessor :configuration

    def configure
      self.configuration ||= Configuration.new
      yield(configuration)
    end
  end
end

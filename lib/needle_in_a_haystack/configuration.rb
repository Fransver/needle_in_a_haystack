module NeedleInAHaystack
  # Holds gem-wide configuration. Configure it from a Rails initializer:
  #
  #   NeedleInAHaystack.configure do |config|
  #     config.ontology_path = Rails.root.join("config/my_ontology.yml")
  #   end
  class Configuration
    # Absolute path to the YAML ontology that describes the tag hierarchy.
    # Defaults to the ontology shipped with the gem.
    attr_accessor :ontology_path

    # Optional list of model names that include +NeedleInAHaystack::Taggable+.
    # Purely informational; useful for host apps that want to introspect or
    # iterate over their taggable models.
    attr_accessor :taggable_models

    def initialize
      @ontology_path = NeedleInAHaystack.default_ontology_path
      @taggable_models = []
    end
  end
end

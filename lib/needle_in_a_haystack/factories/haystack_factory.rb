module NeedleInAHaystack
  # Creates tags and taggings. Tag creation is delegated to a pluggable
  # {TagStrategy}, so the same factory can drive either ad-hoc tagging
  # ({DefaultTagStrategy}) or ontology import ({OntologyTagStrategy}).
  class HaystackFactory < BaseFactory
    attr_accessor :tag_strategy

    def initialize(tag_strategy = DefaultTagStrategy.new)
      super()
      @tag_strategy = tag_strategy
    end

    def create_tag(name, description)
      tag_strategy.create_tag(name, description)
    end

    def create_tagging(tag, taggable)
      HaystackTagging.create(haystack_tag: tag, taggable: taggable)
    end

    def find_or_create_tag(name, attributes = {})
      tag = HaystackTag.find_or_create_by(name: name)
      tag_strategy.update_tag(tag, attributes)
      tag
    end

    # Recursively walks a nested ontology hash, creating a tag per node and
    # wiring up parent/child relationships.
    #
    # Tags are found-or-created scoped to their parent, so names that legitimately
    # repeat under different parents (e.g. "smartMeter" under both elecMeter and
    # gasMeter) become distinct nodes. Re-running the import is idempotent.
    def create_tags(tag_hash, parent_tag = nil)
      tag_hash.each do |name, data|
        next if %w[description children].include?(name)

        tag = HaystackTag.find_or_create_by(name: name, parent_tag_id: parent_tag&.id)
        tag_strategy.update_tag(tag, description: data["description"], haystack_marker: data["marker"])
        create_tags(data["children"], tag) if data["children"]
      end
    end
  end
end

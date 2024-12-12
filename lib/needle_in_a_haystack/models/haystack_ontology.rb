require "yaml"

module NeedleInAHaystack
  # Reads the YAML ontology and materialises it into {HaystackTag} records.
  #
  # The ontology is a nested hash where every node carries a +description+, an
  # optional +marker+, and an optional +children+ hash:
  #
  #   site:
  #     description: A geographical location
  #     children:
  #       building:
  #         description: A structure on a site
  #
  # This is a plain Ruby object (not an ActiveRecord model): it owns no table.
  class HaystackOntology
    class << self
      # The parsed ontology hash, memoised. Source file is taken from
      # +NeedleInAHaystack.configuration.ontology_path+.
      def tags
        @tags ||= YAML.load_file(NeedleInAHaystack.configuration.ontology_path)
      end

      # Clears the memoised ontology. Mainly useful in tests, or after changing
      # the configured +ontology_path+ at runtime.
      def reload!
        @tags = nil
      end

      # Looks up a node by a dotted path ("site.building.floor"), descending
      # through each node's +children+. Returns the node hash augmented with
      # "name" and "path", or nil when any segment is missing.
      def find_tag(path)
        return nil if path.nil? || path.empty?

        segments = path.split(".")
        node = tags[segments.first]
        return nil unless node.is_a?(Hash)

        segments.drop(1).each do |segment|
          children = node["children"]
          return nil unless children.is_a?(Hash) && children[segment].is_a?(Hash)

          node = children[segment]
        end

        node.merge("name" => segments.last, "path" => segments.join("."))
      end

      # Materialises the entire ontology as {HaystackTag} records.
      def import_full_ontology
        factory.create_tags(tags)
      end
      alias create_tags import_full_ontology

      # Finds or creates a single tag (by dotted path or name) from the ontology.
      def find_or_create_tag(path)
        tag_data = find_tag(path)
        return nil if tag_data.nil?

        factory.find_or_create_tag(
          tag_data["name"],
          description: tag_data["description"],
          haystack_marker: tag_data["marker"]
        )
      end

      private

      def factory
        HaystackFactory.new(OntologyTagStrategy.new)
      end
    end
  end
end

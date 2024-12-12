class HaystackOntology < ApplicationRecord
  def self.tags
    @tags ||= YAML.load_file(Rails.root.join("config/haystack_ontology.yml"))
  end

  def self.find_tag(path)
    return nil if path.nil?

    path.include?(".") ? find_tag_in_hierarchy(tags, path.split(".")) : find_tag_in_hierarchy(tags, [path])
  end

  # This method recursively searches for a tag in a nested hash structure.
  # - `current_hash`: The current level of the hash being searched.
  # - `keys`: An array of keys representing the path to the desired tag.
  # - `path`: An array to keep track of the current path (used for constructing the full path of the tag).
  def self.find_tag_in_hierarchy(current_hash, keys, path = [])
    return nil unless current_hash.is_a?(Hash) && keys.any?

    if current_hash[keys.first].is_a?(Hash)
      path.push(keys.shift)
      return current_hash[path.last].merge("path" => path.join(".")) if keys.empty?

      find_tag_in_hierarchy(current_hash[path.last], keys, path)
    else
      current_hash[keys.shift]
    end
  end

  def self.create_tags
    factory = HaystackFactory.new(OntologyTagStrategy.new)
    factory.create_tags(tags)
  end

  def self.find_or_create_tag(name)
    factory = HaystackFactory.new(OntologyTagStrategy.new)
    tag_data = find_tag(name)
    return nil if tag_data.nil?

    attributes = { description: tag_data["description"], haystack_marker: tag_data["marker"] }
    factory.find_or_create_tag(name, attributes)
  end

  def self.import_full_ontology
    create_tags
  end
end

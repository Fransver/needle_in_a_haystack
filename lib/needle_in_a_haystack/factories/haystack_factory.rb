class HaystackFactory < BaseFactory
  attr_accessor :tag_strategy

  def initialize(tag_strategy = DefaultTagStrategy.new)
    super()
    @tag_strategy = tag_strategy
  end

  def create_tag(name, description)
    @tag_strategy.create_tag(name, description)
  end

  def create_tagging(tag, taggable)
    HaystackTagging.create(haystack_tag: tag, taggable: taggable)
  end

  def find_or_create_tag(name, attributes = {})
    tag = HaystackTag.find_or_create_by(name: name)
    tag.persisted? ? @tag_strategy.update_tag(tag, attributes) : tag.update(attributes)
    tag
  end

  def create_tags(tag_hash, parent_tag = nil)
    tag_hash.each do |name, data|
      next if %w[description children].include?(name)

      tag = find_or_create_tag(name, description: data["description"], haystack_marker: data["marker"])
      tag.update(parent_tag_id: parent_tag&.id)
      Rails.logger.info("Created tag: #{tag.name}, Parent: #{parent_tag&.name}, Parent ID: #{parent_tag&.id}")
      create_tags(data["children"], tag) if data["children"]
    end
  end
end

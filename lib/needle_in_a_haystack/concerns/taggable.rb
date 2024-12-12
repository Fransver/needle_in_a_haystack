# This model represents an entity that can be tagged with HaystackTags through HaystackTaggings.
class Taggable < ApplicationRecord
  has_many :haystack_taggings, as: :taggable, dependent: :destroy
  has_many :haystack_tags, through: :haystack_taggings

  def add_haystack_marker(marker)
    self.tags ||= {}
    self.tags[marker] = true
    save!
  end

  def add_haystack_tag(key, value)
    self.tags ||= {}
    self.tags[key] = value
    save!
  end

  def add_multiple_tags(tags_hash)
    self.tags ||= {}
    self.tags.merge!(tags_hash)
    save!
  end
end

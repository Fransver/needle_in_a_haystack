require "active_support/concern"

module NeedleInAHaystack
  # Mixin that turns any ActiveRecord model into a Haystack-taggable record.
  #
  #   class Point < ApplicationRecord
  #     include NeedleInAHaystack::Taggable
  #   end
  #
  #   point.add_haystack_tag(temperature_tag)
  #   point.haystack_tagged_with?("temp") # => true
  #   Point.tagged_with(temperature_tag)  # => ActiveRecord::Relation
  #
  # The association is polymorphic, so any number of unrelated models can be
  # tagged from the same shared tag hierarchy.
  module Taggable
    extend ActiveSupport::Concern

    included do
      has_many :haystack_taggings,
               as: :taggable,
               class_name: "NeedleInAHaystack::HaystackTagging",
               dependent: :destroy
      has_many :haystack_tags, through: :haystack_taggings
    end

    class_methods do
      # Records carrying *all* of the given tags.
      def tagged_with(*tags)
        tags = tags.flatten.compact
        return none if tags.empty?

        joins(:haystack_tags)
          .where(haystack_tags: { id: tags.map(&:id) })
          .group("#{table_name}.#{primary_key}")
          .having("COUNT(DISTINCT haystack_tags.id) = ?", tags.size)
      end

      # Records carrying *any* of the given tags.
      def tagged_with_any(*tags)
        tags = tags.flatten.compact
        return none if tags.empty?

        joins(:haystack_tags).where(haystack_tags: { id: tags.map(&:id) }).distinct
      end
    end

    # Attaches +tag+ unless it is already present. Returns the tagging (or the
    # existing one). +tag+ may be a HaystackTag or anything with an +id+.
    def add_haystack_tag(tag)
      haystack_taggings.find_or_create_by(haystack_tag_id: tag.id)
    end

    # Attaches several tags at once. Accepts tags or an array of tags.
    def add_haystack_tags(*tags)
      tags.flatten.compact.map { |tag| add_haystack_tag(tag) }
    end

    # Removes +tag+ from this record. Returns true when something was removed.
    def remove_haystack_tag(tag)
      haystack_taggings.where(haystack_tag_id: tag.id).destroy_all.any?
    end

    # True when this record carries a tag with the given name.
    def haystack_tagged_with?(name)
      haystack_tags.exists?(name: name)
    end
  end
end

module NeedleInAHaystack
  # Polymorphic join model connecting a {HaystackTag} to any taggable record.
  class HaystackTagging < BaseTagging
    self.table_name = "haystack_taggings"

    belongs_to :haystack_tag, class_name: "NeedleInAHaystack::HaystackTag"
    belongs_to :taggable, polymorphic: true

    validates :haystack_tag_id, uniqueness: { scope: %i[taggable_type taggable_id] }
  end
end

class HaystackTagging < BaseTagging
  belongs_to :haystack_tag, class_name: "HaystackTag"
  belongs_to :taggable, polymorphic: true
end

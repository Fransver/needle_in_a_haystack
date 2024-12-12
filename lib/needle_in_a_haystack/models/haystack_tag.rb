module NeedleInAHaystack
  # A node in the Haystack tag hierarchy. Every tag may have one parent and any
  # number of children, forming a tree. Tags are attached to records through
  # {HaystackTagging} (see {Taggable}).
  class HaystackTag < BaseTag
    self.table_name = "haystack_tags"

    belongs_to :parent_tag, class_name: "NeedleInAHaystack::HaystackTag", optional: true
    has_many :children,
             class_name: "NeedleInAHaystack::HaystackTag",
             foreign_key: "parent_tag_id",
             dependent: :destroy,
             inverse_of: :parent_tag
    has_many :haystack_taggings,
             class_name: "NeedleInAHaystack::HaystackTagging",
             dependent: :destroy

    validates :name, presence: true, uniqueness: { scope: :parent_tag_id, message: :duplicate_in_scope }
    validates :description, presence: true
    validate :prevent_circular_reference

    # Ancestors ordered nearest-first (parent, grandparent, ... , root).
    # Cycle-safe: stops if it ever revisits a node.
    def ancestors
      result = []
      current = parent_tag
      while current && result.exclude?(current)
        result << current
        current = current.parent_tag
      end
      result
    end

    # Human-readable path from the root down to this tag, e.g. "site > building".
    def full_path
      ([self] + ancestors).reverse.map(&:name).join(" > ")
    end

    # Resolves a dotted path ("site.building.floor") to a tag, walking the tree
    # one segment at a time. Returns nil when any segment is missing.
    def self.find_by_path(path)
      return nil if path.nil?

      path.split(".").reduce(nil) do |current, name|
        scope = current ? current.children : where(parent_tag_id: nil)
        tag = scope.find_by(name: name)
        return nil if tag.nil?

        tag
      end
    end

    # All descendants, retrieved breadth-first with one query per tree level
    # (instead of one query per node).
    def descendants
      result = []
      level = children.to_a
      until level.empty?
        result.concat(level)
        level = self.class.where(parent_tag_id: level.map(&:id)).to_a
      end
      result
    end

    def siblings
      if parent_tag
        parent_tag.children.where.not(id: id)
      else
        self.class.where(parent_tag_id: nil).where.not(id: id)
      end
    end

    def root?
      parent_tag_id.nil?
    end

    def leaf?
      !children.exists?
    end

    def depth
      ancestors.size
    end

    # Name of the root tag this node descends from (its top-level category).
    def category
      (ancestors.last || self).name
    end

    private

    def prevent_circular_reference
      return unless parent_tag == self || ancestors.include?(self)

      errors.add(:parent_tag, :circular_reference)
    end
  end
end

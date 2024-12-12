require "yaml"
class HaystackTag < BaseTag
  # PATH_ONTOLOGY = "/Users/frans/Documents/fouriq/fouriq_haystack/config/haystack_ontology.yml"
  PATH_ONTOLOGY = "/Users/frans/Documents/fouriq/fouriq_haystack/config/haystack_ontology.yml"

  belongs_to :parent_tag, class_name: "HaystackTag", optional: true
  has_many :children, class_name: "HaystackTag", foreign_key: "parent_tag_id", dependent: :destroy, inverse_of: :parent_tag
  has_many :haystack_taggings, dependent: :destroy
  has_many :taggables, through: :haystack_taggings, source: :taggable, source_type: "Taggable"

  validates :name, presence: true, uniqueness: { scope: :parent_tag_id, message: I18n.t(:validate_uniqueness) }
  validates :description, presence: true
  validate :prevent_circular_reference
  validate :ensure_identity

  CATEGORIES = YAML.load_file(PATH_ONTOLOGY)

  def ancestors
    ancestors = []
    current = self
    while current.parent_tag
      break if ancestors.include?(current.parent_tag)

      ancestors << current.parent_tag
      current = current.parent_tag
    end
    ancestors
  end

  def full_path
    "#{ancestors.reverse.map(&:name).join(' > ')} > #{name}"
  end

  def self.find_by_path(path)
    keys = path.split(".")
    current = nil
    keys.each do |key|
      current = current ? current.children.find_by(name: key) : find_by(name: key)
      return nil unless current
    end
    current
  end

  def descendants
    children + children.flat_map(&:descendants)
  end

  def siblings
    parent_tag ? parent_tag.children.where.not(id: id) : self.class.where(parent_tag_id: nil).where.not(id: id)
  end

  def root?
    parent_tag.nil?
  end

  def leaf?
    children.empty?
  end

  def depth
    ancestors.size
  end

  def category
    ancestors.empty? ? name : parent_tag.category
  end

  private

  def prevent_circular_reference
    return unless parent_tag == self || ancestors.include?(self)

    errors.add(:parent_tag, I18n.t(:validate_circular_reference))
  end

  def ensure_identity
    return if root? && name == category

    return unless HaystackTag.where(name: name).any? { |tag| tag.category == category }

    Rails.logger.error("Duplicate tag found: #{name} within category: #{category}")
    errors.add(:name, I18n.t(:validate_uniqueness))
  end
end

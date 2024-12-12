module NeedleInAHaystack
  # Abstract base class documenting the interface for tagging join models that
  # connect a tag to a taggable record.
  class BaseTagging < ApplicationRecord
    self.abstract_class = true

    def tag
      raise NotImplementedError, "#{self.class} must implement #tag"
    end

    def taggable
      raise NotImplementedError, "#{self.class} must implement #taggable"
    end
  end
end

class BaseTagging < ApplicationRecord
  self.abstract_class = true

  def tag
    raise NotImplementedError, "Subclasses must implement a tag-method"
  end

  def taggable
    raise NotImplementedError, "Subclasses must implement a taggable-method"
  end
end

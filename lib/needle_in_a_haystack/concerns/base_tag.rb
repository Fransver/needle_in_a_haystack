class BaseTag < ApplicationRecord
  self.abstract_class = true

  def full_path
    raise NotImplementedError, "Subclasses must implement a full_path-method"
  end

  def prevent_circular_reference
    raise NotImplementedError, "Subclasses must implement a prevent_circular_reference-method"
  end

  def ancestors
    raise NotImplementedError, "Subclasses must implement an ancestors-method"
  end

  def descendants
    raise NotImplementedError, "Subclasses must implement a descendants-method"
  end

  def siblings
    raise NotImplementedError, "Subclasses must implement a siblings-method"
  end

  def root?
    raise NotImplementedError, "Subclasses must implement a root?-method"
  end

  def leaf?
    raise NotImplementedError, "Subclasses must implement a leaf?-method"
  end
end

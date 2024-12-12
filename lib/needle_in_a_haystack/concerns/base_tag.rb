module NeedleInAHaystack
  # Abstract base class that documents the interface every concrete tag model
  # must provide. It exists so alternative tag implementations can share a
  # common, enforced contract.
  class BaseTag < ApplicationRecord
    self.abstract_class = true

    def full_path
      raise NotImplementedError, "#{self.class} must implement #full_path"
    end

    def ancestors
      raise NotImplementedError, "#{self.class} must implement #ancestors"
    end

    def descendants
      raise NotImplementedError, "#{self.class} must implement #descendants"
    end

    def siblings
      raise NotImplementedError, "#{self.class} must implement #siblings"
    end

    def root?
      raise NotImplementedError, "#{self.class} must implement #root?"
    end

    def leaf?
      raise NotImplementedError, "#{self.class} must implement #leaf?"
    end

    private

    def prevent_circular_reference
      raise NotImplementedError, "#{self.class} must implement #prevent_circular_reference"
    end
  end
end

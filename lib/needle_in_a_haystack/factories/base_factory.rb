module NeedleInAHaystack
  # Interface for tag/tagging factories. Concrete factories combine a creation
  # strategy with persistence behaviour.
  class BaseFactory
    def create_tag(_name, _description)
      raise NotImplementedError, "#{self.class} must implement #create_tag"
    end

    def create_tagging(_tag, _taggable)
      raise NotImplementedError, "#{self.class} must implement #create_tagging"
    end

    def find_or_create_tag(_name, _attributes = {})
      raise NotImplementedError, "#{self.class} must implement #find_or_create_tag"
    end
  end
end

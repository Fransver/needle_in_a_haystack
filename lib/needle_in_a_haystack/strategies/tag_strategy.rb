module NeedleInAHaystack
  # Interface for tag-creation strategies used by {HaystackFactory}.
  class TagStrategy
    def create_tag(_name, _description)
      raise NotImplementedError, "#{self.class} must implement #create_tag"
    end

    def update_tag(_tag, _attributes)
      raise NotImplementedError, "#{self.class} must implement #update_tag"
    end
  end
end

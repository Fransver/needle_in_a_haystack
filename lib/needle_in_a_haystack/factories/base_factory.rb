class BaseFactory
  def create_tag(name, description)
    raise NotImplementedError, "Subclasses must implement a create_tag-method"
  end

  def create_tagging(tag, taggable)
    raise NotImplementedError, "Subclasses must implement a create_tagging-method"
  end

  def find_or_create_tag(name, attributes = {})
    raise NotImplementedError, "Subclasses must implement a find_or_create_tag-method"
  end
end

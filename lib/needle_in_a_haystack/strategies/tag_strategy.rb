class TagStrategy
  def create_tag(name, description)
    raise NotImplementedError, "#{self.class} has not implemented method '#{__method__}'"
  end

  def update_tag(tag, attributes)
    raise NotImplementedError, "#{self.class} has not implemented method '#{__method__}'"
  end
end

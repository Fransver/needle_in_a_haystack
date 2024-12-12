class DefaultTagStrategy < TagStrategy
  def create_tag(name, description)
    HaystackTag.create(name: name, description: description)
  end

  def update_tag(tag, attributes)
    tag.update(attributes)
  end
end

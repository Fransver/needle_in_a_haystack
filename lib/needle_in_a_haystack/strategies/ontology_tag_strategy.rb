class OntologyTagStrategy < TagStrategy
  def create_tag(name, description)
    HaystackTag.find_or_create_by(name: name).tap do |tag|
      tag.update(description: description)
    end
  end

  def update_tag(tag, attributes)
    tag.update(attributes)
  end
end

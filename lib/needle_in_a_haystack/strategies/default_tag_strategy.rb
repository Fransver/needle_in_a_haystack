module NeedleInAHaystack
  # Straightforward tag creation/updates for ad-hoc tagging.
  class DefaultTagStrategy < TagStrategy
    def create_tag(name, description)
      HaystackTag.create(name: name, description: description)
    end

    def update_tag(tag, attributes)
      tag.update(attributes)
      tag
    end
  end
end

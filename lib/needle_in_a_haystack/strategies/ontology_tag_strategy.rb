module NeedleInAHaystack
  # Tag creation tuned for ontology import: it finds-or-creates by name so the
  # same ontology can be imported repeatedly without creating duplicates.
  class OntologyTagStrategy < TagStrategy
    def create_tag(name, description)
      HaystackTag.find_or_create_by(name: name).tap do |tag|
        tag.update(description: description)
      end
    end

    def update_tag(tag, attributes)
      tag.update(attributes)
      tag
    end
  end
end

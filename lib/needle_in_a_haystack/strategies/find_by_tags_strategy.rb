module NeedleInAHaystack
  # Finds records associated with *any* of the given tags.
  #
  #   strategy = NeedleInAHaystack::FindByTagsStrategy.new(Point, [t1, t2])
  #   NeedleInAHaystack::QueryContext.new(strategy).execute
  class FindByTagsStrategy < QueryStrategy
    def initialize(model, tags)
      super()
      @model = model
      @tags = Array(tags)
    end

    def execute
      @model.joins(:haystack_tags)
            .where(haystack_tags: { id: @tags.map(&:id) })
            .distinct
    end
  end
end

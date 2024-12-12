module NeedleInAHaystack
  # Finds records associated with a single given tag.
  #
  #   strategy = NeedleInAHaystack::FindPointsWithTagStrategy.new(Point, tag)
  #   NeedleInAHaystack::QueryContext.new(strategy).execute
  class FindPointsWithTagStrategy < QueryStrategy
    def initialize(model, tag)
      super()
      @model = model
      @tag = tag
    end

    def execute
      @model.joins(:haystack_tags).where(haystack_tags: { id: @tag.id })
    end
  end
end

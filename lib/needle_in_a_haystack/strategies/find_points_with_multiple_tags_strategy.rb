module NeedleInAHaystack
  # Finds records associated with *all* of the given tags (set intersection).
  #
  #   strategy = NeedleInAHaystack::FindPointsWithMultipleTagsStrategy.new(Point, [t1, t2])
  #   NeedleInAHaystack::QueryContext.new(strategy).execute
  class FindPointsWithMultipleTagsStrategy < QueryStrategy
    def initialize(model, tags)
      super()
      @model = model
      @tags = Array(tags)
    end

    def execute
      @model.joins(:haystack_tags)
            .where(haystack_tags: { id: @tags.map(&:id) })
            .group("#{@model.table_name}.#{@model.primary_key}")
            .having("COUNT(DISTINCT haystack_tags.id) = ?", @tags.size)
    end
  end
end

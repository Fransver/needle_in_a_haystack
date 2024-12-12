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

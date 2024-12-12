class FindByTagsStrategy < QueryStrategy
  def initialize(model, tags)
    super()
    @model = model
    @tags = tags
  end

  def execute
    @model.joins(:haystack_tags).where(haystack_tags: { id: @tags.map(&:id) })
  end
end

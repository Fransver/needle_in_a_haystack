class QueryContext
  def initialize(strategy)
    @strategy = strategy
  end

  def execute
    @strategy.execute
  end
end

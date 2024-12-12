class QueryStrategy
  def execute
    raise NotImplementedError, "Subclasses must implement the execute method"
  end
end

module NeedleInAHaystack
  # Abstract base for query strategies. Subclasses implement {#execute} and
  # return an ActiveRecord::Relation, so results stay composable and lazy.
  class QueryStrategy
    def execute
      raise NotImplementedError, "#{self.class} must implement #execute"
    end
  end
end

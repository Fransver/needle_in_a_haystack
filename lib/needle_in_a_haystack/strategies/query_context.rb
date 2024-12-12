module NeedleInAHaystack
  # Runs a {QueryStrategy}. Lets calling code swap query behaviour without
  # caring which concrete strategy is in play.
  #
  #   context = NeedleInAHaystack::QueryContext.new(strategy)
  #   context.execute
  class QueryContext
    attr_reader :strategy

    def initialize(strategy)
      @strategy = strategy
    end

    def execute
      strategy.execute
    end
  end
end

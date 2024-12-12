class Configuration
  attr_accessor :taggable_models

  def initialize
    @taggable_models = []
  end
end

def self.configuration
  @configuration ||= Configuration.new
end

def self.configure
  yield(configuration)
end

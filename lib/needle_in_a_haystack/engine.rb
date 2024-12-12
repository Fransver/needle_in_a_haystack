class Engine < ::Rails::Engine
end

raise "Gem 'needle_in_a_haystack' is not loaded" unless Gem.loaded_specs["needle_in_a_haystack"]

Gem.loaded_specs["needle_in_a_haystack"].dependencies.each do |d|
  require d.name
end

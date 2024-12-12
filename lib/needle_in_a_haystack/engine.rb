require "rails/engine"

module NeedleInAHaystack
  # Minimal Rails engine. It deliberately does NOT call `isolate_namespace`
  # so that the models keep their conventional table names (`haystack_tags`,
  # `haystack_taggings`) instead of being prefixed with `needle_in_a_haystack_`.
  #
  # The engine's only job is to make the gem's migrations available to the
  # host application, so consumers can run:
  #
  #   bin/rails needle_in_a_haystack:install:migrations
  #   bin/rails db:migrate
  class Engine < ::Rails::Engine
    engine_name "needle_in_a_haystack"

    initializer "needle_in_a_haystack.append_migrations" do |app|
      next if app.root.to_s == root.to_s

      config.paths["db/migrate"].expanded.each do |expanded_path|
        app.config.paths["db/migrate"] << expanded_path
      end
    end
  end
end

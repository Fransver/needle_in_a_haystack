require_relative "boot"
require "rails"
require "active_model/railtie"
require "active_job/railtie"
require "active_record/railtie"
require "action_controller/railtie"
require "action_view/railtie"

Bundler.require(*Rails.groups)

module NeedleInAHaystack
  # Host application used to exercise the engine's test suite. The gem itself is
  # loaded by Bundler (via the `gemspec` directive in the Gemfile), which
  # requires `lib/needle_in_a_haystack.rb` and all of its files explicitly, so
  # there is no need to add `lib` to the Zeitwerk autoload paths.
  class Application < Rails::Application
    config.load_defaults 7.1
  end
end

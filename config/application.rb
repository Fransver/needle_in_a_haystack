require_relative "boot"
require "rails"
require "active_model/railtie"
require "active_job/railtie"
require "active_record/railtie"
require "action_controller/railtie"
require "action_view/railtie"

Bundler.require(*Rails.groups)

module NeedleInAHaystack
  class Application < Rails::Application
    config.autoload_paths += %W[#{config.root}/lib]
  end
end

Rails.application.configure do
  # Settings specified here will take precedence over those in config/application.rb.
  config.cache_classes = true
  config.eager_load = true
  config.consider_all_requests_local = false
  config.public_file_server.enabled = ENV["RAILS_SERVE_STATIC_FILES"].present?
  config.log_level = :debug
  config.log_tags = [:request_id]
  config.i18n.fallbacks = true
  config.active_support.deprecation = :notify
  config.log_formatter = ::Logger::Formatter.new
  logger           = ActiveSupport::Logger.new(STDOUT)
  config.logger    = ActiveSupport::TaggedLogging.new(logger)
  config.lograge.enabled = true
  config.lograge.formatter = Lograge::Formatters::Json.new
end

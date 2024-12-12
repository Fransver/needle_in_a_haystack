Rails.application.configure do
  # Settings specified here will take precedence over those in config/application.rb.
  config.hosts.clear
  config.consider_all_requests_local = true
  config.eager_load = false

  if Rails.root.join("tmp/caching-dev.txt").exist?
    config.cache_store = :memory_store
    config.public_file_server.headers = {
      "Cache-Control" => "public, max-age=#{2.days.to_i}"
    }
  else
    config.action_controller.perform_caching = false

    config.cache_store = :null_store
  end

  config.active_support.deprecation = :log
  config.file_watcher = ActiveSupport::EventedFileUpdateChecker
end

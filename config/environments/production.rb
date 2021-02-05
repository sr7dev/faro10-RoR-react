require Rails.root.join("config/smtp")

Rails.application.configure do
  if ENV.fetch("HEROKU_APP_NAME", "").include?("staging-pr-")
    ENV["APPLICATION_HOST"] = ENV["HEROKU_APP_NAME"] + ".herokuapp.com"
    ENV["ASSET_HOST"] = "https://" + ENV["APPLICATION_HOST"]
  end

  # config.middleware.use Rack::CanonicalHost, ENV.fetch("APPLICATION_HOST"), ignore: "*.herokuapp.com"
  config.cache_classes = true
  config.eager_load = true
  config.consider_all_requests_local       = false
  config.action_controller.perform_caching = true
  # config.serve_static_files = ENV['RAILS_SERVE_STATIC_FILES'].present?
  config.middleware.use Rack::Deflater
  config.assets.js_compressor = :uglifier
  config.assets.compile = false
  config.assets.digest = true
  config.log_level = :info
  config.force_ssl = true
  config.action_controller.asset_host = ENV.fetch("ASSET_HOST", ENV.fetch("APPLICATION_HOST"))
  config.action_mailer.asset_host = config.action_controller.asset_host
  config.action_mailer.delivery_method = :smtp
  config.action_mailer.smtp_settings = SMTP_SETTINGS
  config.active_storage.service = :local
  config.i18n.fallbacks = true
  config.active_support.deprecation = :notify
  config.log_formatter = ::Logger::Formatter.new
  config.log_tags = [ :request_id ]
  if ENV["RAILS_LOG_TO_STDOUT"].present?
    logger           = ActiveSupport::Logger.new(STDOUT)
    logger.formatter = config.log_formatter
    config.logger    = ActiveSupport::TaggedLogging.new(logger)
  end
  config.active_record.dump_schema_after_migration = false
  config.action_mailer.default_url_options = { host: ENV.fetch("APPLICATION_HOST") }
  config.action_mailer.perform_caching = false
  config.textris_delivery_method = :twilio
end
Rack::Timeout.timeout = (ENV["RACK_TIMEOUT"] || 10).to_i

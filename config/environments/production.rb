Leadpump::Application.configure do
  # Settings specified here will take precedence over those in config/application.rb

  # Code is not reloaded between requests
  SERVER_URL = "signin.leadpump.com"
  STRIPE_API_KEY = "sk_live_uZbFMn8jJDxYhcWBJMRz4kZS"
  STRIPE_PUB_KEY = "pk_live_IEcenF7CwslP7o1kXeRcYCQS"
  
  FACEBOOK_KEY = "563196563757857"
  FACEBOOK_SECRET = "ac0561d3179ef6507205091ccc4bb018"
  
  GMAIL_KEY = "BSt-gSNSovq5iqQ8b01WcmlQ"
  GMAIL_SECRET = "124660366124-6q04kuaps32m6qk248d9p0vvuuek56j5.apps.googleusercontent.com"

  YAHOO_KEY = "0e3144bc3873c87a36439f404c3753a240feaec7"
  YAHOO_SECRET = "dj0yJmk9VDd0UG5Ncm96VXFVJmQ9WVdrOVlYTmtjMnRFTjJjbWNHbzlNekl6T0RZd05qWXkmcz1jb25zdW1lcnNlY3JldCZ4PTdm"

  PDF_PATH = "/usr/bin/wkhtmltopdf.sh"


  config.cache_classes = true

  # Full error reports are disabled and caching is turned on
  config.consider_all_requests_local       = false
  config.action_controller.perform_caching = true

  # Disable Rails's static asset server (Apache or nginx will already do this)
  config.serve_static_assets = false

  # Compress JavaScripts and CSS
  config.assets.compress = true

  # Don't fallback to assets pipeline if a precompiled asset is missed
  config.assets.compile = true

  # Generate digests for assets URLs
  config.assets.digest = true

  # Defaults to nil and saved in location specified by config.assets.prefix
  # config.assets.manifest = YOUR_PATH

  # Specifies the header that your server uses for sending files
  # config.action_dispatch.x_sendfile_header = "X-Sendfile" # for apache
  # config.action_dispatch.x_sendfile_header = 'X-Accel-Redirect' # for nginx

  # Force all access to the app over SSL, use Strict-Transport-Security, and use secure cookies.
  # config.force_ssl = true

  # See everything in the log (default is :info)
  # config.log_level = :debug

  # Prepend all log lines with the following tags
  # config.log_tags = [ :subdomain, :uuid ]

  # Use a different logger for distributed setups
  # config.logger = ActiveSupport::TaggedLogging.new(SyslogLogger.new)

  # Use a different cache store in production
  # config.cache_store = :mem_cache_store

  # Enable serving of images, stylesheets, and JavaScripts from an asset server
  # config.action_controller.asset_host = "http://assets.example.com"

  # Precompile additional assets (application.js, application.css, and all non-JS/CSS are already added)
  # config.assets.precompile += %w( search.js )

  # Disable delivery errors, bad email addresses will be ignored
  config.action_mailer.raise_delivery_errors = true
  config.action_mailer.perform_deliveries = true

  # Enable threaded mode
  # config.threadsafe!

  # Enable locale fallbacks for I18n (makes lookups for any locale fall back to
  # the I18n.default_locale when a translation can not be found)
  config.i18n.fallbacks = true

  # Send deprecation notices to registered listeners
  config.active_support.deprecation = :notify

  config.action_mailer.default_url_options = { :host => SERVER_URL }
  config.action_mailer.delivery_method = :smtp

  # Log the query plan for queries taking more than this (works
  # with SQLite, MySQL, and PostgreSQL)
  # config.active_record.auto_explain_threshold_in_seconds = 0.5
end

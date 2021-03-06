Leadpump::Application.configure do
  # Settings specified here will take precedence over those in config/application.rb

  # In the development environment your application's code is reloaded on
  # every request. This slows down response time but is perfect for development
  # since you don't have to restart the web server when you make code changes.
  SERVER_URL = "localhost:3000"
  STRIPE_API_KEY = "sk_test_CSZ1ZaPwKkUnqoy9CRHVOaBA"
  STRIPE_PUB_KEY = "pk_test_tPb28bRAb7DWYFpeU9l8oKhB"

  FACEBOOK_KEY = "468207766612651"
  FACEBOOK_SECRET = "34084682effefb870f5d4b6115463bb6"

  GMAIL_KEY = "BwJTLUiL8eIj510FTv4nhf9v"
  GMAIL_SECRET = "608684261069-rbrbj98g11mld8lhhrbto536rcg20c9c.apps.googleusercontent.com"

  YAHOO_KEY = "0e3144bc3873c87a36439f404c3753a240feaec7"
  YAHOO_SECRET = "dj0yJmk9VDd0UG5Ncm96VXFVJmQ9WVdrOVlYTmtjMnRFTjJjbWNHbzlNekl6T0RZd05qWXkmcz1jb25zdW1lcnNlY3JldCZ4PTdm"
  
  PDF_PATH = "/usr/bin/wkhtmltopdf"

  config.cache_classes = false

  # Log error messages when you accidentally call methods on nil.
  config.whiny_nils = true

  # Show full error reports and disable caching
  config.consider_all_requests_local       = true
  # Don't care if the mailer can't send
  config.action_controller.perform_caching = false  

  # Print deprecation notices to the Rails logger
  config.active_support.deprecation = :log

  # Only use best-standards-support built into browsers
  config.action_dispatch.best_standards_support = :builtin

  # Raise exception on mass assignment protection for Active Record models
  config.active_record.mass_assignment_sanitizer = :strict
  # Log the query plan for queries taking more than this (works
  # with SQLite, MySQL, and PostgreSQL)
  config.active_record.auto_explain_threshold_in_seconds = 0.5

  # Do not compress assets
  config.assets.compress = false
  config.serve_static_assets = false

  # Expands the lines which load the assets
  config.assets.debug = false

  

  config.action_mailer.default_url_options = { :host => SERVER_URL }

  # ActionMailer Config
  config.action_mailer.raise_delivery_errors = true
  config.action_mailer.delivery_method = :smtp

  Paperclip.options[:command_path] = "/usr/bin/"

  config.after_initialize do
  # Bullet.enable = false
  # Bullet.alert = true
  # Bullet.bullet_logger = true
  # Bullet.console = true
  # #Bullet.growl = true
  # # Bullet.xmpp = { :account  => 'bullets_account@jabber.org',
  # #                 :password => 'bullets_password_for_jabber',
  # #                 :receiver => 'your_account@jabber.org',
  # #                 :show_online_status => true }
  # Bullet.rails_logger = true
  # Bullet.airbrake = true
  # Bullet.add_footer = true
end
  
end

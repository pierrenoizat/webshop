Depot::Application.configure do
  # Settings specified here will take precedence over those in config/application.rb

  # The production environment is meant for finished, "live" apps.
  # Code is not reloaded between requests
  config.cache_classes = true

  # Full error reports are disabled and caching is turned on
  config.consider_all_requests_local       = false
  config.action_controller.perform_caching = true

  # Specifies the header that your server uses for sending files
  config.action_dispatch.x_sendfile_header = "X-Sendfile"

  # For nginx:
  # config.action_dispatch.x_sendfile_header = 'X-Accel-Redirect'

  # If you have no front-end server that supports something like X-Sendfile,
  # just comment this out and Rails will serve the files

  # See everything in the log (default is :info)
  # config.log_level = :debug

  # Use a different logger for distributed setups
  # config.logger = SyslogLogger.new

  # Use a different cache store in production
  # config.cache_store = :mem_cache_store

  # Disable Rails's static asset server
  # In production, Apache or nginx will already do this
  # config.serve_static_assets = false
  config.serve_static_assets = true # required to serve the pdf invoice file
  # config.action_controller.perform_caching = true
  # config.assets.digest = true
  # Enable serving of images, stylesheets, and javascripts from an asset server
  # config.action_controller.asset_host = "http://assets.example.com"

  # Disable delivery errors, bad email addresses will be ignored
  config.action_mailer.raise_delivery_errors = false

  # Enable threaded mode
  # config.threadsafe!

  # Enable locale fallbacks for I18n (makes lookups for any locale fall back to
  # the I18n.default_locale when a translation can not be found)
  config.i18n.fallbacks = true

  # Send deprecation notices to registered listeners
  config.active_support.deprecation = :notify

  # Uncomment this to test e-mails in development mode

   config.action_mailer.delivery_method = :smtp

 config.action_mailer.smtp_settings = {
    :address => "smtp.gmail.com",
    :port => 587,
    :domain => "google.com",
    :authentication => "plain",
    :user_name => "microbitcoin", # email will be sent from microbitcoin@gmail.com, replace with your own email (gmail) user name
    :password => "9974800057590488400653131798!", # replace with your own email password
    :enable_starttls_auto  => true
  }
  
  # Used to broadcast invoices public URLs
#  config.base_url = "http://localhost:3000"
  config.base_url = "http://pure-scrubland-5338.herokuapp.com" # replace with your own production platform
  $MAIN_URL = "http://pure-scrubland-5338.herokuapp.com" # replace with your own production platform

end

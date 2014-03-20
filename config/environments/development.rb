Depot::Application.configure do
  # Settings specified here will take precedence over those in config/application.rb

  # In the development environment your application's code is reloaded on
  # every request.  This slows down response time but is perfect for development
  # since you don't have to restart the webserver when you make code changes.
  config.cache_classes = false

  # Log error messages when you accidentally call methods on nil.
  config.whiny_nils = true

  # Show full error reports and disable caching
  config.consider_all_requests_local       = true
  # config.action_view.debug_rjs             = true
  config.action_controller.perform_caching = false

  # if the mailer can't send
  config.action_mailer.raise_delivery_errors = true

  # Print deprecation notices to the Rails logger
  config.active_support.deprecation = :log

  # Only use best-standards-support built into browsers
  config.action_dispatch.best_standards_support = :builtin

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
  
  config.action_mailer.perform_deliveries = false # comment OUT to have emails DELIVERED

  # Used to broadcast invoices public URLs
 config.base_url = "http://127.0.0.1:3000"
 $MAIN_URL = "http://127.0.0.1:3000" # 127.0.0.1 = localhost
 
 # Paperclip.options[:command_path] = "/usr/local/bin/"
 
end


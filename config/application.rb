require File.expand_path('../boot', __FILE__)

require 'rails/all'

# If you have a Gemfile, require the gems listed there, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(:default, Rails.env) if defined?(Bundler)

module Depot
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Custom directories with classes and modules you want to be autoloadable.
    # config.autoload_paths += %W(#{config.root}/extras)

    # Only load the plugins named here, in the order given (default is alphabetical).
    # :all can be used as a placeholder for all plugins not explicitly named.
    # config.plugins = [ :exception_notification, :ssl_requirement, :all ]

    # Activate observers that should always be running.
    # config.active_record.observers = :cacher, :garbage_collector, :forum_observer

    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    # config.time_zone = 'Central Time (US & Canada)'
    config.i18n.available_locales = [:en, :fr]
    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    config.i18n.load_path += Dir[Rails.root.join('config', 'locales','**', '*.{rb,yml}').to_s]
    config.i18n.default_locale = :fr
    
    ActionController::Base.config.relative_url_root = ''

    # Configure the default encoding used in templates for Ruby 1.9.
    config.encoding = "utf-8"
	$DEFAULT_RATE = 500 # default conversion rate, Euro to BTC, in application_helper, in case of json error.
	$MARGIN_RATE = 1.15 # margin over Bitcoin Charts EUR/BTC average rate
	$CONV_RATE = $DEFAULT_RATE
	$UNCONFIRMED_TX_URL = "http://blockchain.info/unconfirmed-transactions?format=json"
	$RAWADDRESS_URL = "http://blockchain.info/rawaddr/" # http://blockchain.info/rawaddr/$bitcoin_address
	
	# $EXCHANGE_RATE_URL = "http://bitcoincharts.com/t/weighted_prices.json"
	# $EXCHANGE_RATE_URL = "http://api.bitcoincharts.com/v1/weighted_prices.json"
	$EXCHANGE_RATE_URL = "http://api.coindesk.com/v1/bpi/currentprice.json" # used in application_controller get_rate
	$EXCHANGE_RATE_SOURCE = "http://www.coindesk.com/price" # used in views/layouts/application.html.erb
	
	$EUROPE = ["Albania", "Andorra","Austria", "Belgium", "Bosnia and Herzegowina", 
        "Bulgaria", "Croatia", "Cyprus", "Czech Republic", "Denmark",
        "Estonia", "Finland", "France","Germany", "Gibraltar", "Greece", "Guernsey",
        "Holy See (Vatican City State)", "Hungary", "Iceland", "Ireland", "Isle of Man", "Italy", "Jersey",
        "Latvia","Liechtenstein", "Lithuania", "Luxembourg","Monaco", "Montenegro", "Netherlands",
        "Poland", "Portugal", "Romania", "San Marino", "Serbia", "Slovakia", "Slovenia",
        "Spain", "Sweden", "Switzerland", "United Kingdom"]
        
	# replace with your own master public key
	# MPK for microbitcoin.fr
	# $MPK = 'c56b2f46fe68c07d616ab218019fb9065493590a4bb1fb030c51d532c5598b6a834e4595e4cb7f89f07d409659078b7aa5d47026cf887ee6658910eb1d38629a'
	
	# MPK for Association Bitcoin France
	$MPK = 'a145a1779d9f37f7e1eb535e9511bd773a0c71c3b02d45791304e9bec2d70801d86600675d8ad8a2ac8292b30a5df838f0b926b827105e6e1ed028aea7d40731'
	
    # Configure sensitive parameters which will be filtered from the log file.
    config.filter_parameters += [:password]
  end
end

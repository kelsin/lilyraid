# Be sure to restart your server when you modify this file

# Uncomment below to force Rails into production mode when
# you don't control web/app server and can't set it the proper way
ENV['RAILS_ENV'] ||= 'production'

# Specifies gem version of Rails to use when vendor/rails is not present
RAILS_GEM_VERSION = '2.0.2' unless defined? RAILS_GEM_VERSION

# Bootstrap the Rails environment, frameworks, and default configuration
require File.join(File.dirname(__FILE__), 'boot')

require 'icalendar-1.0.2/lib/icalendar'

Rails::Initializer.run do |config|
  # Skip frameworks you're not going to use (only works if using vendor/rails).
  # To use Rails without a database, you must remove the Active Record framework
  config.frameworks -= [ :active_resource, :action_mailer ]

  # Add additional load paths for your own custom dirs
  config.load_paths += %W( #{RAILS_ROOT}/app/sweepers )

  # For Newer Rails
  # config.gem "dbi"
  # config.gem "mysql"

  # Your secret key for verifying cookie session data integrity.
  # If you change this key, all old sessions will become invalid!
  # Make sure the secret is at least 30 characters and all random, 
  # no regular words or you'll be exposed to dictionary attacks.
  config.action_controller.session = {
    :session_key => '_dotaraid_session',
    :secret      => '2758ab2bc0cad94f094e1c65991604155e74c98a9d320c76b81a931a96314121aa3cbb234063bb5eee5a3091938551de132cd722f0b7f9f55a94cac839069f72'
  }

  # Make Active Record use UTC-base instead of local time
  # config.active_record.default_timezone = :utc
end

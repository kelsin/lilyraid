# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_cod_session',
  :secret      => '2758ab2bc0cad94f094e1c65991604155e74c98a9d320c76b81a931a96314121aa3cbb234063bb5eee5a3091938551de132cd722f0b7f9f55a94cac839069f72'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store


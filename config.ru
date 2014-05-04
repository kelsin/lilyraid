# Require your environment file to bootstrap Rails
require ::File.dirname(__FILE__) + '/config/environment'

# Dispatch the request
use Rails::Rack::Static
run ActionController::Dispatcher.new

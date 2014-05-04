set :rails_env, "cod"
set :application, "lilyraid-cod"
set :deploy_to, '/home/app/www/lilyraid-cod'

server 'kelsin.net', user: 'app', roles: %w{web app db}

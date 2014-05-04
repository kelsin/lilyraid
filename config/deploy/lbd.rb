set :rails_env, "lbd"
set :application, "lilyraid-lbd"
set :deploy_to, '/home/app/www/lilyraid-lbd'

server 'kelsin.net', user: 'app', roles: %w{web app db}

set :rails_env, "dota"
set :application, "lilyraid-dota"
set :deploy_to, '/home/app/www/lilyraid-dota'

server 'kelsin.net', user: 'app', roles: %w{web app db}

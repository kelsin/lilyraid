# config valid only for Capistrano 3.1
lock '3.2.1'

# set :application, 'lilyraid'
set :repo_url, 'git@github.com:Kelsin/lilyraid.git'

set :user, 'app'
# set :deploy_to, '/home/app/www/lilyraid'

# Default value for :linked_files is []
set :linked_files, %w{config/database.yml config/config.yml}

# Default value for linked_dirs is []
set :linked_dirs, %w{log tmp/pids tmp/cache tmp/sockets vendor/bundle}

set :rbenv_type, :user
set :rbenv_ruby, '1.9.2-p290'

namespace :deploy do
  desc 'Restart application'
  task :restart do
    invoke 'unicorn:restart'
  end

  after :publishing, :restart
end

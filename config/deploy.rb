require "bundler/capistrano"

set :stages, %w(cod dota lbd)
require 'capistrano/ext/multistage'

set :application, "lilyraid"
set :rails_env, "development"

# If you aren't deploying to /u/apps/#{application} on the target
# servers (which is the default), you can specify the actual location
# via the :deploy_to variable:
# set :deploy_to, "/var/www/#{application}"

# If you aren't using Subversion to manage your source code, specify
# your SCM below:
# set :scm, :subversion
set :scm, :git
set :repository, "git@github.com:Kelsin/lilyraid.git"
set :branch, "master"
set :deploy_via, :remote_cache

set :user, 'kelsin'
set :ssh_options, { :forward_agent => true }

role :app, "kelsin.net"
role :web, "kelsin.net"
role :db,  "kelsin.net", :primary => true

namespace :deploy do
  task :start, :roles => :app do
    run "touch #{current_release}/tmp/restart.txt"
  end

  task :stop, :roles => :app do
    # Do nothing.
  end

  desc "Restart Application"
  task :restart, :roles => :app do
    run "touch #{current_release}/tmp/restart.txt"
  end

  desc "Symlink database and config files"
  task :symlink_shared, :roles => :app do
    ['database.yml', 'config.yml', 'initializers/airbrake.rb', 'initializers/secret_token.rb', 'initializers/session_store.rb'].each do |path|
      run "ln -nfs #{shared_path}/config/#{path} #{release_path}/config/#{path}"
    end
  end
end

after 'deploy:update_code', 'deploy:symlink_shared'

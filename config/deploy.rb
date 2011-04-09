require 'bundler/capistrano'

set :stages, %w(cod dota)
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
 
role :app, "valefor.com"
role :web, "valefor.com"
role :db,  "valefor.com", :primary => true

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
    run "ln -nfs #{shared_path}/config/database.yml #{release_path}/config/database.yml"
    run "ln -nfs #{shared_path}/config/config.yml #{release_path}/config/config.yml"
  end
end

after 'deploy:update_code', 'deploy:symlink_shared'

Dir[File.join(File.dirname(__FILE__), '..', 'vendor', 'gems', 'hoptoad_notifier-*')].each do |vendored_notifier|
  $: << File.join(vendored_notifier, 'lib')
end

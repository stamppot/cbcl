# Required for using Mongrel with Capistrano2
#   gem install palmtree

require 'palmtree/recipes/mongrel_cluster'

########################################################################
# Rails Boxcar - Capistrano Deployment Recipe
# Configuration
######################################################################## 
# What is the name of your application? (no spaces)
# Example: 
#   set :application_name, 'my_cool_app'
set :application_name, 'cbcl'

# What is the hostname of your Rails Boxcar server?
# Example: 
#   set :boxcar_server, 'rc1.railsboxcar.com'
set :boxcar_server, '67.214.211.55' # Planet Argon: '198.145.115.222' # change to fx test.cbcl-sdu.dk

# What is the username of your Rails Boxcar user that you want
# to deploy this application with? Note that you should use the same
# username and password as you use to access your repository. This is
# due to a limitation in Capistrano.

set :boxcar_username, 'cbcl'

# Where is your source code repository?
#
# Subversion Example:
#
#set :user, 'rubyurl'
#set :repository, 'https://svn.roundhaus.com/planetargon/rubyurl_2-0/trunk'
#
# If you won't be making any code changes on the boxcar itself, it's
# a good idea to do an export instead of a checkout (default) so that
# you avoid all of the .svn cruft.
#set :deploy_via, :export

#
# Git Example:
#   
set :scm, "git"
set :repository, "git://github.com/stamppot/cbcl.git"

# If you're using git submodules in your project, enable support for them
# by uncommenting the following
#set :git_enable_submodules, 1

# Store a local copy of your project on the server and only pull changes.
# Significantly speeds up deployments.
set :deploy_via, :remote_cache

# Allows you to use your local SSH key during deployments instead of creating
# a separate deployment user key with no password.
# ssh_options[:forward_agent] = true

###################################################
# PASSENGER (mod_rails) SUPPORT
###################################################
#
# Boxcar Conductor is optimized to work with Phusion Passenger. If you are planning
# on using mongrel + nginx, comment out the following block.
namespace :deploy do
  desc "Restart Application"
  task :restart, :roles => :app do
    run "touch #{current_path}/tmp/restart.txt"
  end

  desc "Start Application"
  task :start, :roles => :app do
    # Do nothing to prevent errors during deploy:cold
  end
end

###################################################
# CUSTOM TASKS
###################################################
#
# By default, Boxcar Conductor will add symlinks for the following:
#   * config/database.yml
#   * log/  
# 
# If you'd like to have Boxcar Conductor symlink any other files and/or directories,
# you can add in a custom task at the bottom of this deploy.rb by following this example:
#
# namespace :example do
#   desc "Link more remote files" 
#   task :link_remote_files do
#     run "ln -nfs #{app_shared_dir}/data #{release_path}/data"
#     run "ln -nfs #{app_shared_dir}/exports #{release_path}/public/exports"    
#   end
# end
# 
# after "boxcar:deploy:link_files", "example:link_remote_files"
#

# Thinking Sphinx
namespace :thinking_sphinx do
  task :configure, :roles => [:app] do
    run "cd #{current_path}; rake thinking_sphinx:configure RAILS_ENV=#{rails_env}"
  end
  task :index, :roles => [:app] do
    run "cd #{current_path}; rake thinking_sphinx:index RAILS_ENV=#{rails_env}"
  end
  task :start, :roles => [:app] do
    run "cd #{current_path}; rake thinking_sphinx:start RAILS_ENV=#{rails_env}"
  end
  task :stop, :roles => [:app] do
    run "cd #{current_path}; rake thinking_sphinx:stop RAILS_ENV=#{rails_env}"
  end
  task :restart, :roles => [:app] do
    run "cd #{current_path}; rake thinking_sphinx:restart RAILS_ENV=#{rails_env}"
  end
end

# Thinking Sphinx typing shortcuts
namespace :ts do
  task :configure, :roles => [:app] do
    run "cd #{current_path}; rake thinking_sphinx:configure RAILS_ENV=#{rails_env}"
  end
  task :in, :roles => [:app] do
    run "cd #{current_path}; rake thinking_sphinx:index RAILS_ENV=#{rails_env}"
  end
  task :start, :roles => [:app] do
    run "cd #{current_path}; rake thinking_sphinx:start RAILS_ENV=#{rails_env}"
  end
  task :stop, :roles => [:app] do
    run "cd #{current_path}; rake thinking_sphinx:stop RAILS_ENV=#{rails_env}"
  end
  task :restart, :roles => [:app] do
    run "cd #{current_path}; rake thinking_sphinx:restart RAILS_ENV=#{rails_env}"
  end
end
set :boxcar_username, 'cbcl'
set :user, 'cbcl'

load 'deploy' if respond_to?(:namespace) # cap2 differentiator
load 'config/deploy'
Dir['vendor/plugins/boxcar-conductor/tasks/*.rb'].each { |plugin| load(plugin) }

load 'deploy' if respond_to?(:namespace) # cap2 differentiator
Dir['vendor/plugins/*/recipes/*.rb'].each { |plugin| load(plugin) }
load 'config/deploy'
require 'thinking_sphinx/deploy/capistrano'
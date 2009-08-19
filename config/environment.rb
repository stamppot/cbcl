# Be sure to restart your web server when you modify this file.

# Uncomment below to force Rails into production mode when 
# you don't control web/app server and can't set it the proper way
ENV['RAILS_ENV'] ||= 'production'

# Specifies gem version of Rails to use when vendor/rails is not present
# RAILS_GEM_VERSION = '2.3.3'

# Bootstrap the Rails environment, frameworks, and default configuration
require File.join(File.dirname(__FILE__), 'boot')
require 'memcache'

$KCODE = 'u'
#require 'jcode'

# Rails.backtrace_cleaner.remove_silencers!   

Rails::Initializer.run do |config|

  # load vendored gems
  config.load_paths += Dir["#{RAILS_ROOT}/vendor/gems/**"].map do |dir| 
    File.directory?(lib = "#{dir}/lib") ? lib : dir
  end
  
  # auto-load gems in vendor
  Dir[File.dirname(__FILE__) + "/../vendor/*"].each do |path|
    gem_name = File.basename(path.gsub(/-\d+.\d+.\d+$/, ''))
    gem_path = path + "/lib/" + gem_name + ".rb"
    require gem_path if File.exists? gem_path
  end
  
  # Settings in config/environments/* take precedence those specified here
  
  # Skip frameworks you're not going to use
  # config.frameworks -= [ :action_web_service, :action_mailer ]

  # Add additional load paths for your own custom dirs
  # config.load_paths += %W( #{RAILS_ROOT}/extras )

  # Force all environments to use the same logger level 
  # (by default production uses :info, the others :debug)
  # config.log_level = :debug

  # Use the database for sessions instead of the file system
  # (create the session table with 'rake db:sessions:create')
  # config.action_controller.session_store = :active_record_store

  # Use SQL instead of Active Record's schema dumper when creating the test database.
  # This is necessary if your schema can't be completely dumped by the schema dumper, 
  # like if you have constraints or database-specific column types
  # config.active_record.schema_format = :sql

  # Activate observers that should always be running
  # config.active_record.observers = :cacher, :garbage_collector

  config.action_controller.session = { :session_key => "_cbcl_online_session", :secret => '0001237daee31bffae5fd8dc02313d' }

  # Make Active Record use UTC-base instead of local time
  config.active_record.default_timezone = :utc
  
  config.action_controller.relative_url_root = ""
  # See Rails::Configuration for more options
  config.gem 'mislav-will_paginate', :version => '~> 2.3.11', :lib => 'will_paginate', 
      :source => 'http://gems.github.com'

  mem_cache_options = {
    :c_threshold => 10000,
    :compression => true,
    :debug => false,
    :timeout => false,
    :namespace => 'app',
    :readonly => false,
    :urlencode => false
  }
  config.action_controller.cache_store = :mem_cache_store_with_delete_matched, ['127.0.0.1:11211'], mem_cache_options      
end

ThinkingSphinx.suppress_delta_output = true

# config.cache_store = :my_mem_cache_store

require "will_paginate"

WillPaginate::ViewHelpers.pagination_options[:previous_label] = 'Forrige'
WillPaginate::ViewHelpers.pagination_options[:next_label] = 'Næste'


EXPORT_FILES_STORAGE_PATH = "./files/"
# ActionMailer::Base.server_settings = { 
#   :address => 'cbcl-sdu.dk',
#   :authentication => :login,
#   :domain => 'cbcl-sdu.dk',
#   :user_name => 'info@cbcl-sdu.dk',
#   :password => 'cbcl-sdu'
# }

CACHE = MemCache.new('127.0.0.1') #if false #ENV['RAILS_ENV'] == 'production'


module Enumerable
  def foldr(o, m = nil)
    reverse.inject(m) {|m, i| m ? i.send(o, m) : i}
  end

  def foldl(o, m = nil)
    inject(m) {|m, i| m ? m.send(o, i) : i}
  end
end
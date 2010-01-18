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
  
  config.gem 'ar-extensions'
end

ThinkingSphinx.suppress_delta_output = true

# config.cache_store = :my_mem_cache_store

require "will_paginate"
require 'facets/dictionary'

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

class Hash
  # return Hash with nil values removed
  def compact
    delete_if {|k,v| !v }
  end

  # array-style push of key-values
  def <<(hash={})
    merge! hash
  end
end

#example: journals = entries.build_hash { |elem| [elem.journal_id, elem.survey_id] }
module Enumerable
  def foldr(o, m = nil)
    reverse.inject(m) {|m, i| m ? i.send(o, m) : i}
  end

  def foldl(o, m = nil)
    inject(m) {|m, i| m ? m.send(o, i) : i}
  end

  def build_hash
    is_hash = false
    inject({}) do |target, element|
      key, value = yield(element)
      is_hash = true if !is_hash && value.is_a?(Hash)
      if is_hash
        target[key] = {} unless target[key]
        target[key].merge! value
      else
        target[key] = [] unless target[key]
        target[key] << value
      end
      target
    end
  end

  # creates a hash with elem as key, result of block as value
  def to_hash
    result = {}
    each do |elt|
      result[elt] = yield(elt)
    end
    result
  end
  # creates a hash with result of block as key, elem as value
  def to_hash_with_key
    result = {}
    each do |elt|
      result[yield(elt)] = elt
    end
    result
  end

  def collect_if(condition)
    inject([]) do |target, element|
      value = yield(element)
      target << value if element.send(condition) #eval("element.#{condition}")
      target
    end
  end
end

# http://mspeight.blogspot.com/2007/06/better-groupby-ingroupsby-for.html
class Array
  def in_groups_by
    # Group elements into individual array's by the result of a block
    # Similar to the in_groups_of function.
    # NOTE: assumes array is already ordered/sorted by group !!
    curr=nil.class 
    result=[]
    each do |element|
      group=yield(element) # Get grouping value
      result << [] if curr != group # if not same, start a new array
      curr = group
      result[-1] << element
    end
    result
  end

  # fill 2-d array so all rows has equal number of items
  def fill_2d(obj = nil)
    # find longest
    longest = self.max { |a,b| a.length <=> b.length }.size
    self.each do |row|
      row[longest-1] = obj if row.size < longest  # fill with nulls
    end
    return self
  end
  
  def to_h
    Hash[*self]
  end
end

class Float
  def to_danish
    ciphers = self.to_s.split(".")
    return ciphers[0] + "," + ciphers[1]
  end
end

class Fixnum
  def to_roman
    value = self
    str = ""
    (str << "C"; value = value - 100) while (value >= 100)
    (str << "XC"; value = value - 90) while (value >= 90)
    (str << "L"; value = value - 50) while (value >= 50)
    (str << "XL"; value = value - 40) while (value >= 40)
    (str << "X"; value = value - 10) while (value >= 10)
    (str << "IX"; value = value - 9) while (value >= 9)
    (str << "V"; value = value - 5) while (value >= 5)
    (str << "IV"; value = value - 4) while (value >= 4)
    (str << "I"; value = value - 1) while (value >= 1)
    str
  end
end
class CustomNotFoundError < RuntimeError; end
class AccessDenied < StandardError; end

class ApplicationController < ActionController::Base
  include CacheableFlash
  include ExceptionNotification::Notifiable
  layout 'cbcl'

  before_filter :configure_charsets
  before_filter :set_permissions, :except => [:dynamic_data, :logout, :finish]
  before_filter :check_logged_in, :except => [:login]
  before_filter :check_access, :except => [:dynamic_data, :finish, :logout, :shadow_logout]
  before_filter :center_title, :except => [:dynamic_data, :logout, :login]
  before_filter :cookies_required, :except => [:login, :logout, :upgrade]

  filter_parameter_logging :password, :password_confirmation

  def check_logged_in
    if !current_user && !params[:controller] =~ /login/
      store_location
      redirect_to login_path
    end
  end

  def set_permissions
    if current_user
      current_user.perms = Access.for_user(current_user)
    end
  end

  def center_title
    @center_title = if current_user && current_user.center
      current_user.center.title
    else
      "Børne- og Ungdomspsykiatrisk Afdeling Odense"
    end
  end

  def cookies_required
    return unless !request.cookies["session_id"].to_s.blank?
    store_location
    redirect_to(:controller => "start", :action => "upgrade")
    return false
  end

  def require_user
    unless current_user
      store_location
      redirect_to login_path
      return false
    end
  end

  def store_location
    session[:return_to] = request.get? && request.request_uri || request.referer
  end

  def redirect_back_or_default(default)
    redirect_to(session[:return_to] || default)
    session[:return_to] = nil
  end

  def rescue_404
    rescue_action_in_public CustomNotFoundError.new
  end

  def rescue_action_in_public(exception)
    case exception
    when ActiveRecord::RecordNotFound
      render :file => "#{RAILS_ROOT}/public/404.html", :status => 404
    when NoMethodError
      render :file => "#{RAILS_ROOT}/public/404.html", :status => 404
    else
      super
    end
  end

  def remove_user_from_session!
    session[:rbac_user_id] = nil
    session.delete :journal_entry
    cookies.delete :journal_entry
    cookies.delete :user_name
  end

  def filter_date(args)
    if args[:start_date] && args[:stop_date]
      start = args.delete(:start_date)
      stop  = args.delete(:stop_date)
    end
    Query.set_time_args(start, stop, args) # TODO: move to better place/helper?! also used in Query
  end

  # private

  helper_method :current_user
  # This method returns the User model of the currently logged in user or
  # the anonymous user if no user has been logged in yet.
  def current_user
    return @current_user_cached unless @current_user_cached.blank?

    @current_user_cached = 
    if !session[:rbac_user_id].blank?
      User.find(session[:rbac_user_id])
    else
      nil
    end
    return @current_user_cached
  rescue
    puts "def current_user RESCUE #{session[:rbac_user_id]}"
    remove_current_user
    redirect_to login_path
  end

  def remove_current_user
    session[:rbac_user_id] = nil
    @current_user_cached = nil
  end

  helper_method :save_draft_interval
  def save_draft_interval
    current_user.login_user? && 900 || 60
  end

  def journals_per_page
    20
  end

  def local_request?
    return false
  end

  # Filter to send unicode header to the client
  def configure_charsets  # was: set_charset
    content_type = headers["Content-Type"] || "text/html"
    if /^text\//.match(content_type)
      headers["Content-Type"] = "#{content_type}; charset=utf-8" 
    end
  end

  # check_access is implemented in most subclassed controllers (where needed)
  def check_access
    return true if params[:controller] =~ /newrelic|login/
    # check controller
    if !params[:id].blank? && params[:controller] =~ /score|faq/
      if current_user && (current_user.access?(:all_users) || current_user.access?(:login_user))
        if session[:journal_entry]
          logger.info "REQUEST #{params[:controller]}/#{params[:action]} #{'/' + (params[:id] || "")} cookie: '#{session[:journal_entry]}' user: '#{current_user.id}' @ #{9.hours.from_now.to_s(:short)}"
        end
        # cookies_required # redirects if cookies are disabled
        if params[:action] =~ /edit|update|delete|destroy|show|show.*|add|remove/
          # RAILS_DEFAULT_LOGGER.debug "Checking access for user #{current_user.login}:\n#{params[:controller]} id: #{params[:id]}\n\n"
          id = params[:id].to_i
          # puts "checking access... params: #{params.inspect}"
          case params[:controller]
          when /faq/
            access = current_user.access?(:superadmin) || current_user.access?(:admin)
          when /score_reports/  # TODO: test this one!!!
            journal_ids = cache_fetch("journal_ids_user_#{current_user.id}") { current_user.journal_ids }
            access = if params[:answers]
              params[:answers].keys.all? { |entry| journal_ids.include? entry }
            else
              access = journal_ids.include? id
            end
          when /scores/
            access = current_user.access? :superadmin
          when /group|role/
            access = current_user.access? :superadmin
          else
            puts "APP CHECKACCESS #{params.inspect}"
            access = current_user.access? :superadmin
          end
          return access
        end
      else
        puts "ACCESS FAILED: #{params.inspect}"
        params.clear
        redirect_to login_path
      end
    end
    return true
  end

  def escape_javascript(javascript)
    if javascript
      result = javascript.gsub(%r(\\|<\/|\r\n|\3342\2200\2250|[\n\r"'])) {|match| JS_ESCAPE_MAP[match] }
      javascript.html_safe? ? result.html_safe : result
    else
      ''
    end
  end
  
  private
  def cache(key)
    unless output = CACHE.get(key)
      output = yield
      CACHE.set(key, output, 1.hour)
    end
    return output
  end

end

class String
  def escape_single_quotes
    self.gsub(/'/, "\\\\'")
  end
  
  def clean_quotes!
    self.gsub!("%22", "%27") if (self.include?("%22") && self.include?("%27"))
    self
  end
end

class Hash
  # return Hash with nil values removed
  def compact
    delete_if {|k,v| !v }
  end

  # array-style push of key-values
  def <<(hash={})
    merge! hash
  end

  def each_path
    raise ArgumentError unless block_given?
    self.class.each_path( self ) { |path, object| yield path, object }
  end

  protected
  def self.each_path(object, path = '', &block )
    if object.is_a?( Hash ) then object.each do |key, value|
      self.each_path value, "#{ path }#{ key }/", &block
    end
  else yield path, object
  end
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

  def dups
    inject({}) {|h,v| h[v]=h[v].to_i+1; h}.reject{|k,v| v==1}.keys
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

  def to_hash_flat
    is_hash = false
    inject({}) do |target, element|
      key, value = yield(element)
      target[key] = value
      target
    end
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

# def cache_fetch(key, time_expire = 0)
#   if ENV["RAILS_ENV"] == 'development' && !CACHE_DEVELOPMENT
#     yield
#   else
#     CACHE.fetch(key, time_expire){yield} #this is the old way
#     # unless output = CACHE.get(key)
#     #   output = yield
#     #   CACHE.set(key, output, time_expire)
#     # end
#     # return output
#   end
# end
def cache_fetch(key, options = {}, &block)
  if Rails.env.production? 
    Rails.cache.fetch key, options, &block
  else
    yield
  end
end
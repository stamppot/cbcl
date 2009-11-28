# Filters added to this controller will be run for all controllers in the application.
# Likewise, all the methods added will be available for all controllers.
class CustomNotFoundError < RuntimeError; end
class AccessDenied < StandardError; end

class ApplicationController < ActionController::Base
  # include ExceptionNotifiable
  include ActiveRbacMixins::ApplicationControllerMixin

  # expires_in 3.hours, :public => true
  response.headers["Expires"] = "#{1.week.ago}"
  
  self.rails_error_classes = { 
    AccessDenied => "403",
    # PageNotFound => "404",
    # InvalidMethod => "405",
    # ResourceGone => "410",
    # CorruptData => "500",
    # NotImplemented => "501",
    # NameError => "503",
    # TypeError => "503",
    ActiveRecord::RecordNotFound => "400",
    ::ActionController::UnknownController => "404",
    ::ActionController::UnknownAction => "501",
    ::ActionController::RoutingError => "404",
    # ::ActionController::MissingTemplate => "404",
    ::ActionView::TemplateError => "500"
  }
  self.http_error_codes = { "200" => "OK" }
  # self.rails_error_classes = { AccessDenied => "200" }
  self.error_layout = "login"

  # acts_as_current_user_container
  # session :session_key => '_cbcl_session_id'
  layout "survey"

  before_filter :set_permissions
  before_filter :configure_charsets
  before_filter :check_access
  before_filter :center_title

  filter_parameter_logging :password, :password_confirmation

  def set_permissions
    current_user.perms = Access.for_user(current_user) if current_user
  end
  # before_filter :set_locale
  # def set_locale
  #   # if this is nil then I18n.default_locale will be used
  #   I18n.locale = params[:locale] 
  # end

  # def log_user_agent
  #   if params[:controller] == 'login' && params[:action] == 'login' # only track when user logs in
  #     logger.info "LOGIN #{params[:username]}: #{request.env['HTTP_USER_AGENT']}"
  #   return true
  # end

  def center_title
    @center_title = if current_user && current_user.center
      current_user.center.title
    else
      "Børne- og Ungdomspsykiatriske Hus"
    end
  end

  def rescue_404
    rescue_action_in_public CustomNotFoundError.new
  end

  def access_denied
    raise AccessDenied
  end

  private

  # def rescue_action_in_public(exception)
  #   # if response_code_for_rescue(exception) == "404 Page Not Found"
  #   if status_code == :not_found
  #     render :file => "#{RAILS_ROOT}/public/404.html", :layout => false, :status => 404
  #   else
  #     @message = exception.backtrace.join("\n") unless exception
  #     render :file => "#{RAILS_ROOT}/public/404.html", :layout => false, :status => 404
  #   end
  # end



  # def rescue_action_in_public(exception)
  #   case exception
  #     when CustomNotFoundError, ::ActionController::UnknownAction then
  #       #render_with_layout "shared/error404", 404, "standard"
  #       render :template => "main/error404", :layout => false, :status => "404"
  #     when NameError
  #     when ActiveRecord::RecordNotFound
  #       # @message = "Fejl: " + exception.backtrace[0..10].join("\n") unless exception
  #       # @error = "Fejl!"
  #       render :template => "main/error404", :layout => false, :status => "404", :object => @message       
  #     else
  #       @message = exception.backtrace[0..10].join("\n") unless exception
  #       @error = "Fejl!"
  #       render :template => "main/error", :layout => "login", :status => "500"
  #   end
  # end

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
    # check controller
    if !params[:id].blank? and params[:controller] =~ /score|faq/
      if current_user and (current_user.access?(:all_users) || current_user.access?(:login_user))
        if params[:action] =~ /edit|update|delete|destroy|show|show.*|add|remove/
          # RAILS_DEFAULT_LOGGER.debug "Checking access for user #{current_user.login}:\n#{params[:controller]} id: #{params[:id]}\n\n"
          id = params[:id].to_i
          # puts "checking access... params: #{params.inspect}"
          case params[:controller]
          when /faq/
            access = current_user.access?(:superadmin) || current_user.access?(:admin)
          when /score_reports/  # TODO: test this one!!!
            journal_ids = Rails.cache.fetch("journal_ids_user_#{current_user.id}") { current_user.journal_ids }
            access = if params[:answers]
              params[:answers].keys.all? { |entry| journal_ids.include? entry }
            else
              journal_ids.include? id
            end
          when /scores/
            access = current_user.access? :superadmin
          when /group|role|admin/
            access = current_user.access? :superadmin
          else
            access = current_user.access? :superadmin
          end
          return access
        end
      else
        puts "ACCESS FAILED: #{params.inspect}"
        access_denied
        return false
      end
    end
    return true
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
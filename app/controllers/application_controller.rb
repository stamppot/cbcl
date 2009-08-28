# Filters added to this controller will be run for all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  include ActiveRbacMixins::ApplicationControllerMixin
  
  # acts_as_current_user_container
  # session :session_key => '_cbcl_session_id'
  layout "survey"
  
  before_filter :configure_charsets
  before_filter :check_access
  before_filter :center_title
  
  filter_parameter_logging :password, :password_confirmation
  
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
    puts #{request.env['HTTP_USER_AGENT']}"
    @center_title = if current_user && current_user.center
			current_user.center.title
		else
			"Børne- og Ungdomspsykiatriske Hus"
		end
	end
	
  private

  # def rescue_action_in_public(exception)
  #   if response_code_for_rescue(exception) == "404 Page Not Found"
  #     render :nothing => true, :layout => "404", :status => 404
  #   else
  #     super
  #   end
  # end
  
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
      if current_user and (current_user.has_access?(:all_users) || current_user.has_access?(:login_user))
        if params[:action] =~ /edit|update|delete|destroy|show|show.*|add|remove/
          # RAILS_DEFAULT_LOGGER.debug "Checking access for user #{current_user.login}:\n#{params[:controller]} id: #{params[:id]}\n\n"
          id = params[:id].to_i
          # puts "checking access... params: #{params.inspect}"
          case params[:controller]
          when /faq/
            access = current_user.has_access?(:superadmin) || current_user.has_access?(:admin)
          when /score_reports/  # TODO: test this one!!!
            journal_ids = Rails.cache.fetch("journal_ids_user_#{current_user.id}") { current_user.journal_ids }
            access = if params[:answers]
              params[:answers].keys.all? { |entry| journal_ids.include? entry }
            else
              journal_ids.include? id
            end
          when /scores/
            access = current_user.has_access? :superadmin
          when /group|role|admin/
            access = current_user.has_access? :superadmin
          else
            access = current_user.has_access? :superadmin
          end
          return access
        end
      else
        puts "ACCESS FAILED: #{params.inspect}"
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
end

class Float
  def to_danish
    ciphers = self.to_s.split(".")
    return ciphers[0] + "," + ciphers[1]
  end
end

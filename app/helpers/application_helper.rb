# class Fixnum
#  def to_roman
#   value = self
#   str = ""
#   (str << "C"; value = value - 100) while (value >= 100)
#   (str << "XC"; value = value - 90) while (value >= 90)
#   (str << "L"; value = value - 50) while (value >= 50)
#   (str << "XL"; value = value - 40) while (value >= 40)
#   (str << "X"; value = value - 10) while (value >= 10)
#   (str << "IX"; value = value - 9) while (value >= 9)
#   (str << "V"; value = value - 5) while (value >= 5)
#   (str << "IV"; value = value - 4) while (value >= 4)
#   (str << "I"; value = value - 1) while (value >= 1)
#   str
#  end
# end


# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper

  LINE_LENGTH = 78 unless defined? LINE_LENGTH

  def back_button(url, options = {})
    link_button t('go_back'), url, 'go_back', options.merge(:title => t('go_back'))
  end
  
  def link_button(text, url, btn_type = nil, options = {})
    method = options.delete(:method) || :get
    cssclass = options.delete(:class)
    btn = content_tag(:span, text, {:class => (btn_type.blank? && 'text' || btn_type)})
    link_to btn, url, options.merge(:class => "button #{cssclass}".rstrip, :method => method)
  end

  def link_button_to_remote(text, btn_type, url, options = {})
    method = options.delete(:method) || :get
    cssclass = options.delete(:class)
    btn = content_tag(:span, text, {:class => (btn_type || 'text')})
    link_to_remote(btn, url, options.merge(:class => "button #{cssclass}".rstrip))
  end
  
  # correctly close/open html 4.01 tags
  def stylesheet_link_tag_html4( _n )
    return stylesheet_link_tag( _n ).gsub( ' />', '>' )
  end  

  def img_tag_html4( a, b )
    return image_tag( a, b ).gsub( ' />', '>' )
  end  

  def text_field_tag_html4(name, value = nil, options = {})
    return text_field_tag( name, value, options ).gsub( ' />', '>' )
  end
  
  # This method returns the User model of the currently logged in user or
  # the anonymous user if no user has been logged in yet.
  def current_user
    return @current_user_cached unless @current_user_cached.nil?

    @current_user_cached = 
            if session[:rbac_user_id].nil? then
              nil # ::AnonymousUser.instance
            else
              ::User.find(session[:rbac_user_id])
            end

    return @current_user_cached
  end
  
  # is the logged in used being shadowed by an admin?
  def shadow_user?
    return !session[:shadow_user_id].blank?
  end
  
  include WillPaginate::ViewHelpers 
  def will_paginate_with_i18n(collection, options = {}) 
  will_paginate_without_i18n(collection, options.merge(:previous_label => I18n.t(:previous), :next_label => I18n.t(:next))) 
  end 

  alias_method_chain :will_paginate, :i18n
  
  def create_cell_id(row, col)
    return "cell"+row.to_s + "_" + col.to_s
  end

  def split_string(somestring, length = LINE_LENGTH)
    note = h somestring 
    if note.size > length
      slices = []
      while note.size > length do
        slices << note.slice!(0, length)
      end
      slices << note
      slices.join("</br>")
    else
      somestring
    end
  end
  
  def survey_short(survey)
    survey.title.gsub(/\s\(.*\)/,'')
  end
  
end

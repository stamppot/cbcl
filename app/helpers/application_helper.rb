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


# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper

  LINE_LENGTH = 78 unless defined? LINE_LENGTH

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
  
  # # updates the current user session id
  # def set_current_user(user)
  #   # delete old id first
  #   session[:user_secure_key] = nil
  #   session[:rbac_user_id] = nil
  #   
  #   if user # if anon user, use default salt
  #     user.generate_salt if user.salt.blank?
  #     session[:user_secure_key] = user.id.to_s.crypt(user.password_salt)
  #     session[:rbac_user_id] = user.id.to_s
  #   end
  # end
  # 
  # # context user switch. sets to_user in rbac_user_id. Backs up from_user in shadow
  # def switch_user(from_user, to_user)
  #   # backup admin user
  #   session[:shadow_user_secure_key] = from_user.id.to_s.crypt(from_user.password_salt)
  #   session[:shadow_user_id] = from_user.id.to_s
  #   
  #   # set new user
  #   session[:user_secure_key] = to_user.id.to_s.crypt(to_user.password_salt)
  #   session[:rbac_user_id] = to_user.id.to_s
  #   
  #   # set current user to to_user
  #   @current_user_cached = to_user
  # end
  # 
  # def shadow_user
  #   shadow_user_id    = session[:shadow_user_id_key]
  #   shadow_secure_key = session[:shadow_user_secure_key]
  #   user = User.find(shadow_user_id)
  #   if user.admin? && (shadow_secure_key == user.id.to_s.crypt(user.password_salt))
  #     return user
  #   else
  #     return nil
  #   end
  # end
  
  # is the logged in used being shadowed by an admin?
  def shadow_user?
    return !session[:shadow_user_id].blank?
  end
  # 
  # def remove_shadow_user
  #   session[:shadow_user_id_key] = nil
  # end
  
  
  
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

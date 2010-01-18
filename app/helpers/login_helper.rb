module LoginHelper
  
  # updates the current user session id
  # def set_current_user(user)
  #   # delete old id first
  #   session[:user_secure_key] = nil
  #   session[:rbac_user_id] = nil
  #   
  #   if user # if anon user, use default salt
  #     session[:user_secure_key] = user.id.to_s.crypt(user.password_salt)
  #     session[:rbac_user_id] = user.id.to_s
  #   end
  # end

  # def shadow_user
  #   shadow_user_id    = session[:shadow_user_id]
  #   shadow_secure_key = session[:shadow_user_secure_key]
  #   user = User.find(shadow_user_id)
  #   if user.admin? && (shadow_secure_key == user.id.to_s.crypt(user.password_salt))
  #     return user
  #   else
  #     return nil
  #   end
  # end
  # 
  # def remove_shadow_user
  #   session[:shadow_user_id] = nil
  #   session[:shadow_user_secure_key] = nil
  # end
  
end
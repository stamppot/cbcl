module LoginHelper
  
  # updates the current user session id
  def set_current_user(user)
    # delete old id first
    session[:user_secure_key] = nil
    session[:rbac_user_id] = nil
    
    if user # if anon user, use default salt
      session[:user_secure_key] = user.id.to_s.crypt(user.password_salt)
      session[:rbac_user_id] = user.id.to_s
    end
  end

  # context user switch. sets to_user in rbac_user_id. Backs up from_user in shadow
  # TODO: check that user has rights to change user!!!!
  def switch_user(from_user, to_user)
    return current_user unless current_user.has_access :superadmin
    # backup admin user
    session[:shadow_user_secure_key] = from_user.id.to_s.crypt(from_user.password_salt)
    session[:shadow_user_id] = from_user.id.to_s

    # set new user
    session[:user_secure_key] = to_user.id.to_s.crypt(to_user.password_salt)
    session[:rbac_user_id] = to_user.id.to_s

    # set current user to to_user
    @current_user_cached = to_user
  end
  
  def shadow_user
    shadow_user_id    = session[:shadow_user_id]
    shadow_secure_key = session[:shadow_user_secure_key]
    user = User.find(shadow_user_id)
    if user.admin? && (shadow_secure_key == user.id.to_s.crypt(user.password_salt))
      return user
    else
      return nil
    end
  end
  
  def remove_shadow_user
    session[:shadow_user_id] = nil
    session[:shadow_user_secure_key] = nil
  end
  
end
# 24-2  A LoginUser is not a special user, but a role a user has!
# 24-3  He is also saved in his own table, NOT!
# Do not obsolete, but use as abstraction/facade of user has role("login_bruger")
class LoginUser < User
  # include ActiveRbacMixins::UserMixin
  
  # does not work, since association is broken
  def journal1
    self.journal_entry.journal
  end
  
  def journal
    self.all_groups.select { |group| group.instance_of? Journal }.first
  end
  
  def survey
    self.journal_entry.survey
  end

  def surveys #  match User method  
    [self.journal_entry.survey]
  end
  
  def survey_answer
    self.journal_entry.survey_answer
  end

  
  # create unique login, name and password
  # todo: sikrere brugernavne
  def self.create(name = "abc")
    password = PasswordService.generate_password
    login = (name.length < 4) ? name + "-login" : name
    phrase = "%" + (login).sub(/\=$/, "") + "%"
    brugerid = (LoginUser.count(:conditions => ["users.login LIKE ?", phrase]) + 1).to_s
    # always add number to login-user   # if username exists, add number to it
    login += brugerid if name.length < 4 or brugerid != "1"
    
    parms = {
      :password => password[:password],
      :password_confirmation => password[:password_confirmation],
      :login => login,
      :name  => login,
      :email => "#{login}@centername.dk",  # fix email
      :state => 2
    }
    @user = LoginUser.new(parms)

    # set password hash type seperatedly because it is protected
    @user.password_hash_type = "md5"    
    return @user
  end
  
end
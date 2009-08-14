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

  # options: role
  # def self.build_login(center, journal, options = nil)
  #   parms = self.login_name_params(options.merge(:center => center.title))
  #   parms[:center] = center
  # 
  #   login_user = LoginUser.new(parms)
  # 
  #   # set password hash type seperatedly because it is protected
  #   login_user.password_hash_type = "md5"    
  # 
  #   # set role & group
  #   login_user.roles << Role.get(options[:role] || :login_user)
  #   login_user.groups << journal
  #   
  #   return login_user
  # end

  # creates parameters for new login user
  # options: prefix => center title
  def self.login_name_params(options = {})
    title = options[:prefix] || "a b c"
    center_name = title.split.map {|w| w.first }.join.downcase
    login = "#{center_name}-login"
    
    phrase = "%" + (login).sub(/\=$/, "") + "%"
    
    # try to find a non-used user id
    user_count = User.count(:conditions => ["users.login LIKE ?", phrase])
    userid = user_count + 1
    increment = 7
    while User.find_by_login(center_name + "#{userid}") do 
      userid = user_count + rand(increment)
      puts "trying with user_id #{center_name}#{userid}"
      increment *= 3
    end
      
    login += userid.to_s
    
    return { :login => login,
             :name => login,
             :email => "login#{userid}@#{center_name}-center.dk",
             :state => 2,
             :login_user => true
           }
  end

  # create unique login, name and password
  # todo: sikrere brugernavne
  # def self.create(name = nil)
  #   password = PasswordService.generate_password
  #   login = "login-" + (name.length < 4) ? name + "-login" : name
  #   phrase = "%" + (login).sub(/\=$/, "") + "%"
  #   brugerid = (LoginUser.count(:conditions => ["users.login LIKE ?", phrase]) + 1).to_s
  #   # always add number to login-user   # if username exists, add number to it
  #   login += brugerid if name.length < 4 or brugerid != "1"
  #   
  #   parms = {
  #     :password => password[:password],
  #     :password_confirmation => password[:password_confirmation],
  #     :login => login,
  #     :name  => login,
  #     :email => "#{login}@center.dk",  # fix email
  #     :state => 2
  #   }
  #   @user = LoginUser.new(parms)
  # 
  #   # set password hash type seperatedly because it is protected
  #   @user.password_hash_type = "md5"    
  #   return @user
  # end
  
end
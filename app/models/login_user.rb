# 24-2  A LoginUser is not a special user, but a role a user has! But also a type
# Do not obsolete, but use as abstraction/facade of user has role("login_bruger")
class LoginUser < User
  
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

  def self.build_login_user(journal_entry)
    params = LoginUser.login_name_params(:prefix => journal_entry.journal.center.title)
    pw = PasswordService.generate_password
    
    login_user = LoginUser.new(params)
    # set protected fields explicitly
    login_user.center_id = journal_entry.journal.center_id
    login_user.roles << Role.get(:login_bruger)
    login_user.groups << journal_entry.journal
    login_user.password, login_user.password_confirmation = pw.values
    login_user.password_hash_type = "md5"
    login_user.last_logged_in_at = 10.years.ago
    journal_entry.password = pw[:password]
    return login_user
    
  rescue => e
    puts "journal_entry.create_login_user: #{e.inspect}"
  end

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
    while !User.find_by_login(center_name + "#{userid}").nil? do 
      userid = user_count + rand(increment)
      increment *= 3
      logger.info "USERID: #{userid}"
    end
      
    login += userid.to_s
    return { :login => login,
             :name => login,
             :email => "login#{userid}@#{center_name}-center.dk",
             :state => 2,
             :login_user => true
           }
  end

  
end
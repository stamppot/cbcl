# 24-2  A LoginUser is not a special user, but a role a user has! But also a type
# Do not obsolete, but use as abstraction/facade of user has role("login_bruger")
class LoginUser < User
  
  default_scope :order => 'id DESC'

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

  def self.create_params(center_name, login_number, email = nil)
    login = "#{center_name}-#{login_number}"
    email ||= "#{login}@#{center_name}.dk"
    return { :login => login,
      :name => login,
      :email => email,
      :state => 2,
      :login_user => true
    }
  end
  
end
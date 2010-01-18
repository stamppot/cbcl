# 24-2  A LoginUser is not a special user, but a role a user has! But also a type
# Do not obsolete, but use as abstraction/facade of user has role("login_bruger")
class LoginUser < User
  
  default_scope :order => 'id DESC'
  
  
  # does not work, since association is broken
  # def journal1
  #   self.journal_entry.journal
  # end
  
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
  
end
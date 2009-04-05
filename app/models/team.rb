class Team < Group
  belongs_to :center

  # named_scope :in_center, lambda { |center| { :conditions => ['center_id = ?', center.is_a?(Center) ? center.id : center] } }

  # team code must be unique within the same center
  def validate_on_create
    if self.center.teams.collect { |t| t.code }.include?(code)
      errors.add(:id, "skal være unik")
    end
  end

  def has_member?(user)
    self.users.include? user
  end
  
  # member of center AND NOT member of team
  def only_center_has_member?(user)
    !self.has_member? user and self.parent.all_users.include? user
  end
    
  # center (and possible team) has member
  def center_has_member?(user)
    self.parent.all_users.include? user
  end
  
  # returns full code (center-team)
  def team_code
    "#{parent.code}-#{self.code}"
  end

  def survey_answers
    # get all journals in team, journal_entries, then survey_answers
    self.children.map { |journal| journal.journal_entries(:include => :survey_answer).answered.map {|je| je.survey_answer} }
    # or just get journal_ids directly
  end
  
  def self.per_page
    15
  end
  
  protected

  # validates_uniqueness_of :title, 
  #                         :message => 'er navnet på et allerede eksisterende team.',
  #                         :if => Proc.new { |group| current_user.teams.map { |t| t.title }.include? group.title }

  validates_numericality_of :code, 
                            :message => 'skal være 3 cifre.'
                                                                                
  validates_presence_of   :parent,
                          :message => ': overordnet gruppe skal vælges',
                          :if => Proc.new { |group| group.class.to_s != "Center" }
end
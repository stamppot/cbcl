class Subscription < ActiveRecord::Base
  belongs_to :center
  belongs_to :survey
  has_many :copies, :dependent => :delete_all

  after_create :add_fresh_copy

  named_scope :for_center, lambda { |center| { :conditions => ['center_id = ?', center.is_a?(Center) ? center.id : center] } }
  named_scope :by_survey, lambda { |survey| { :conditions => ['survey_id = ?', survey.is_a?(Survey) ? survey.id : survey] } }
  
  named_scope :active, :conditions => [ 'state = ?', 1 ]
  named_scope :inactive, :conditions => [ 'state = ?', 2 ]
  named_scope :locked, :conditions => [ 'state = ?', 3 ]
  named_scope :deleted, :conditions => [ 'state = ?', 4 ]
  
  validates_presence_of :survey
  validates_presence_of :center
  
  def add_fresh_copy
    self.copies << Copy.new({:active => true})
  end
  
  def Subscription.states
    Subscription.default_states
  end
  
  def states
    Subscription.default_states
  end
  
  def active?
    Subscription.default_states['Aktiv'] == self.state
  end
  
  def activate!
    self.add_fresh_copy unless self.copies.active.empty?
    self.state = self.states['Aktiv']
    self.save
  end
  
  def deactivate!
    self.state = self.states['Inaktiv']
    self.save
  end

  def find_active_copy
    active_copy = self.copies.active.first
    if active_copy.nil?
      new_copy = Copy.create({:active => true})
      self.copies << new_copy
      self.save
      active_copy = new_copy
    end
    active_copy
  end
  
  def active_copies_used
    active_copy = self.find_active_copy
    if active_copy.nil?
      new_copy = Copy.create({:active => true, :used => 0})
      self.copies << new_copy
      self.save
    else
      active_copy = self.find_active_copy
    end
    return active_copy.used
  end
  
  # subscribed survey has been used
  def copy_used!
    active_copy = find_active_copy
    active_copy.copy_used
    # self.copies_used += 1   # total count
    self.save
  end

  # rolls back last paid copy, sums any use counts
  def set_last_as_unpaid
    active_copy = self.find_active_copy
    if active_copy.nil?
    end
  end
  
  def copies_used
    self.copies.map { |c| c.used }.sum #inject { |sum, n| sum + n }
  end
  
  # consolidate active Copy obj and start new
  def consolidate
    active_copy = find_active_copy
    active_copy.consolidate!
    # self.copies.create_copy({:active => true})
    self.copies << Copy.create({:active => true, :subscription => self})
    # self.save
  end

  def undo_consolidate
    active_copy = find_active_copy
    if active_copy
      used = active_copy.used
      if second_last_copy = self.copies.inactive.consolidated.last
        second_last_copy.used += used
        second_last_copy.unconsolidate!
        active_copy.destroy
      end
    end
  end
  
  def summary(options = {})
    results = case options[:show]
    when "active": copies.active
    when "paid": copies.consolidated
    else 
      copies
    end
    results.group_by { |c| c.created_on }
  end
  
  private
  
    # This method returns a hash which contains a mapping of user states 
    # valid by default and their description.
    def Subscription.default_states
      @default_states ||= {
        'Aktiv' => 1,
        'Inaktiv' => 2,
        'Låst' => 3,
        'Slettet' => 4
      }
    end
end
class Copy < ActiveRecord::Base
  belongs_to :subscription

  named_scope :active, :conditions => ['active = ?', true]
  named_scope :inactive, :conditions => ['active = ?', false]
  named_scope :consolidated, :conditions => ['consolidated = ?', true], :order => 'consolidated_on DESC'

  def active?
    self.active
  end
  
  def start_period
    self.created_on
  end

  def copy_used
    if self.active?
      self.used += 1
      self.save
    else
      false
    end
  end

  def consolidate!
    self.consolidated = true
    self.consolidated_on = Time.now.to_date
    self.active = false
    self.save  # check that consolidated_on is updated
  end

  def unconsolidate!
    self.consolidated = false
    self.consolidated_on = nil
    self.active = true
    self.save
  end
  
  def reset!
    self.used = 0
    self.save
  end
end
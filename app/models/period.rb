class Period < ActiveRecord::Base
  belongs_to :subscription

  named_scope :active, :conditions => ['active = ?', true]
  named_scope :inactive, :conditions => ['active = ?', false]
  named_scope :paid, :conditions => ['paid = ?', true], :order => 'paid_on DESC'

  attr_accessor :survey_id, :center_id, :state


  def survey
    self.survey_id && Survey.find(self.survey_id) || nil
  end

  def center
    self.center_id && Center.find(self.center_id) || nil
  end
  
  def active?
    self.active
  end
  
  def start_on
    self.created_on
  end

  def stopped_on
    self.paid_on
  end

  def stopped_on=(val)
    self.paid_on = val.to_date
  end
  
  def copy_used!
    if self.active?
      self.used += 1
      self.save
    else
      false
    end
  end

  def pay!
    self.paid = true
    self.stopped_on = Time.now
    self.active = false
    self.save  # check that paid_on is updated
  end

  def undo_pay!
    self.paid = false
    self.stopped_on = nil
    self.active = true
    self.save
  end
  
  def reset!
    self.used = 0
    self.save
  end
end
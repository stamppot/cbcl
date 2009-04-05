class FaqSection < ActiveRecord::Base

  has_many :faqs, :order => :position

  acts_as_list

  attr_accessor :current_language
  
  validates_uniqueness_of :position, :title

end

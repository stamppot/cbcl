class ItemOption < ActiveRecord::Base
  belongs_to :item_choice

  def value
    self.code
  end
  
end

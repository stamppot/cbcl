class ItemChoice < ActiveRecord::Base
  has_many :item_options
  has_many :codes
end

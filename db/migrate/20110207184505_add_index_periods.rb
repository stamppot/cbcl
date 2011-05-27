# class AddIndexPeriods < ActiveRecord::Migration
#   def self.up
#     add_index :periods, :active
#     add_index :periods, :paid
#   end
# 
#   def self.down
#     remove_index :periods, :paid
#     remove_index :periods, :active
#   end
# end
# class ChangeRolesToSymbols < ActiveRecord::Migration
#   def self.up
#     login_user = Role.find_by_title("Login-bruger")
#     if login_user
#       login_user.title = "login_bruger"
#       login_user.save
#     end
#     
#     roles = Role.all
#     roles.each do |r|
#       r.title = r.title.downcase
#       r.save
#     end
#   end
# 
#   def self.down
#   end
# end

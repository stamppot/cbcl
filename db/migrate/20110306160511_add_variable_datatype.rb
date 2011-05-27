# class AddVariableDatatype < ActiveRecord::Migration
#   def self.up
#     add_column :variables, :datatype, :string
#     # ss = Survey.all
#     # ss.each do |survey|
#     #   vars = survey.get_variables
#     #   vars.values.each {|v| puts "item: #{v.item} datatype: #{v.datatype}"}
#     #   vars.values.each {| v| v.save}
#     # end
#   end
# 
#   def self.down
#     remove_column :variables, :datatype
#   end
# end
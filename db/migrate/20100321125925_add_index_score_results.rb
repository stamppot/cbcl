# class AddIndexScoreResults < ActiveRecord::Migration
#   def self.up
#     add_index :score_results, :score_rapport_id
#     add_index :score_results, :score_id
#     add_index :score_results, [:score_id, :score_rapport_id]
#   end
# 
#   def self.down
#     remove_index :score_results, :score_id
#     remove_index :score_results, [:score_id, :score_rapport_id]
#     remove_index :score_results, :score_rapport_id
#   end
# end

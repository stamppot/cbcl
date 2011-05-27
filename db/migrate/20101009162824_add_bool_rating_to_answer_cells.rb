# 	def self.up
# 		# remove_column :answer_cells, :answertype
# 
# 		add_column :answer_cells, :rating, :boolean
# 		add_column :answer_cells, :value_text, :string
# 		add_column :answer_cells, :text, :boolean
# 		add_column :answer_cells, :cell_type, :integer
# 		AnswerCell.find_each(:conditions => 'id < 700000 and id > 400000') do |ac|
# 			if ac.answertype == "Rating"
# 				ac.rating = true
# 				ac.text = false
# 			elsif ac.answertype == "ListItem" || ac.answertype == "ListItemComment" || ac.answertype == "TextBox"
# 				ac.rating = false
# 				ac.text = true
# 				ac.value_text = ac.value
# 			else
# 				ac.rating = false
# 				ac.text = false
# 			end
# 			ac.answer_type = ac.answertype
# 			ac.save
# 		end
# 	end
# 
# 	def self.down
# 
# 		remove_column :answer_cells, :cell_type
# 		remove_column :answer_cells, :text
# 		remove_column :answer_cells, :value_text
# 		remove_column :answer_cells, :rating
# 	end
# end

class AddBoolRatingToAnswerCells < ActiveRecord::Migration
  def self.up
    # remove_column :answer_cells, :value
    # add_column :answer_cells, :value, :integer, :nullable => true
  end
end

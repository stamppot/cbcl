class AddQuestion < ActiveRecord::Migration
  def self.up
    change_table :answer_cells do |t|
      t.integer :question_id
    end
  end
end

AddQuestion.up

bad_cells = 0
AnswerCell.find_in_batches(:batch_size => 10000) do |answer_cells| 
  answer_cells.each do |cell| 
    if cell.answer && (q_id = cell.answer.question_id) == 19
      cell.question_id = cell.answer.question_id
      cell.save
    elsif cell.answer.nil?
      bad_cells += 1
      puts cell.inspect
    end
  end
end
puts "bad_cells: #{bad_cells}"
# YSR last question question_id: 19

AnswerCell.find_in_batches(:batch_size => 10000, :conditions => "question_id = 19 and row IN (85,88,105,115)") do |answer_cells| 
  answer_cells.each do |cell| 
    case (cell.row)
    when 85:
      cell.row = 88
      cell.item = "78"
    when 88:
      cell.row = 85
      cell.item = "75"
    when 105:
      cell.row = 115
      cell.item = "105"
    when 115:
      cell.row = 105
      cell.row = "95"
    end
    cell.save
  end
end

    

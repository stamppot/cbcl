class Code < ActiveRecord::Base
  belongs_to :code_book
  belongs_to :item_choice

  def to_s
    "Spg #{question_number} item:#{item} #{variable} #{item_type} : #{description} : #{datatype} : q #{question_id}[#{row}][col]"
  end
end

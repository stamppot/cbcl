class AddNoRatingsCaching < ActiveRecord::Migration
  def self.up
    add_column :questions, :ratings_count, :int
    
    # Question.all.each do |q|
    #   q.ratings_count = q.ratings.size
    #   q.save
    # end

    add_column :answers, :ratings_count, :int # answered ratings count
    
    # unless ENV['RAILS_ENV'] == 'test'
      Answer.all.each do |a|
        a.ratings_count = a.answer_cells.ratings.not_answered.count
        a.save
        a.answer_cells = nil
        a = nil
      end
    # end
    
  end

  def self.down
  end
end

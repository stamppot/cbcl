class AddNoRatingsCaching < ActiveRecord::Migration
  def self.up
    add_column :questions, :ratings_count, :int
    add_column :answers, :ratings_count, :int # answered ratings count
    end
    
  end

  def self.down
    remove_column :questions, :ratings_count
    remove_column :answers, :ratings_count
  end
end

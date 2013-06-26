class AddLetterFollowUp < ActiveRecord::Migration
  def self.up
    add_column :letters, :follow_up, :int
  end

  def self.down
    remove_column :letters, :follow_up
  end
end


class AddLetterCenter < ActiveRecord::Migration
  def self.up
    add_column :letters, :center_id, :int
  end

  def self.down
    remove_column :letters, :center_id
  end

  def self.update
	  Letter.all.each do |l|
      if l.center_id.nil?
        l.center_id = (l.group.is_a?(Team) && l.group.center_id || l.group.id)
        l.save
      end
  	end
  end
end

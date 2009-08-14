class AddCpRtoPersonInfo < ActiveRecord::Migration
  def self.up
    add_column :person_infos, :cpr, :string
    add_index :person_infos, :cpr
    
    PersonInfo.all.each do |info|  # set cpr
      info.cpr = info.birthdate.to_s.split("-").reverse.join
      info.save
    end
  end

  def self.down
    remove_column :person_infos, :cpr
    remove_index :person_infos, :cpr
  end
end

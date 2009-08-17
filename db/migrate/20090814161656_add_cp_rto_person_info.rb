class AddCpRtoPersonInfo < ActiveRecord::Migration
  def self.up
    add_column :person_infos, :cpr, :string
    add_index :person_infos, :cpr
    
    PersonInfo.all.each do |info|  # set cpr
      dato = info.birthdate.to_s.split("-")
      dato[0] = dato[0][2..3]
      info.cpr = dato.reverse.join
      info.save
    end
  end

  def self.down
    remove_column :person_infos, :cpr
    remove_index :person_infos, :cpr
  end
end

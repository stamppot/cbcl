class JournalInformation < ActiveRecord::Migration
  def self.up
    create_table :person_infos do |t|
      t.column :journal_id, :int, :null => false
      t.column :name, :string, :size => 200, :null => false
      t.column :sex, :int, :null => false
      t.column :birthdate, :date, :null => false
      t.column :nationality, :string, :size => 40, :null => false
    end
    # journal entries relate journals with surveys, answers, and login users
    create_table :journal_entries do |t|
      t.column :journal_id, :int, :null => false
      t.column :survey_id, :int, :null => false
      t.column :user_id, :int
      t.column :password, :string
      t.column :survey_answer_id, :int
      t.column :created_at, :datetime
      t.column :answered_at, :datetime
      t.column :state, :int, :null => false  # ikke besvaret, besvaret, venter på svar (login-user)
    end
    create_table :nationalities do |t|
      t.column :country, :string, :limit => 40
      t.column :country_code, :string, :limit => 4
    end
    
    # insert nationalities
    execute "INSERT INTO `nationalities` VALUES (1,'Dansk','DK'),(2,'Svensk','SVE'),(3,'Norsk','NOR'),(4,'Islandsk','ISL'),(5,'Tysk','DE'),(6,'Uoplyst',''),(7,'Adopteret',''),(8,'Indvandrer/flygtning',''),(9,'Andet','');"
  end

  def self.down
    drop_table :journal_entries
    drop_table :nationalities
    drop_table :person_infos
  end
end

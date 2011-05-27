class JournalInformation < ActiveRecord::Migration
  def self.up
    create_table :person_infos do |t|
      t.column :journal_id, :int, :null => false
      t.column :name, :string, :size => 200, :null => false
      t.column :sex, :int, :null => false
      t.column :birthdate, :date, :null => false
      t.column :nationality, :string, :size => 40, :null => false
      t.column :cpr, :string, :size => 10
      t.column :delta, :boolean, :default => true, :null => false
      t.column :updated_at, :datetime
      t.index :delta
      t.index :cpr
      t.index :journal_id
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
      t.index :state
      t.index :journal_id
      t.index :survey_id
      t.index :survey_answer_id
    end
    create_table :nationalities do |t|
      t.column :country, :string, :limit => 40
      t.column :country_code, :string, :limit => 4
    end    
  end

  def self.down
    drop_table :journal_entries
    drop_table :nationalities
    drop_table :person_infos
  end
end

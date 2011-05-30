require 'db/migration_helpers'

class JournalInformation < ActiveRecord::Migration
  extend MigrationHelpers

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
    add_foreign_key('person_infos', 'fk_person_infos_journals', 'journal_id', 'groups', 'id')
    
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
      t.column :updated_at, :datetime
      t.index :state
      t.index :journal_id
      t.index :survey_id
      t.index :survey_answer_id
      t.index :user_id
    end
    add_foreign_key('journal_entries', 'fk_journal_entries_journals', 'journal_id', 'groups', 'id')
    add_foreign_key('journal_entries', 'fk_journal_entries_surveys', 'survey_id', 'surveys', 'id')
    add_foreign_key('journal_entries', 'fk_journal_entries_users', 'user_id', 'users', 'id')
    # reciprocally defined
    # add_foreign_key('journal_entries', 'fk_journal_entries_survey_answers', 'survey_answer_id', 'survey_answers', 'id')

    create_table :nationalities do |t|
      t.column :country, :string, :limit => 40
      t.column :country_code, :string, :limit => 4
    end    
  end

  def self.down
    drop_table :person_infos if table_exists? :person_infos
    drop_table :journal_entries if table_exists? :journal_entries
    drop_table :nationalities if table_exists? :nationalities
  end
end

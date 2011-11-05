class CreateExportJournalInfo < ActiveRecord::Migration 
  def self.up
    create_table :export_journal_infos do |t|
      t.integer :survey_answer_id, :journal_entry_id, :journal_id, :center_id, :pid
      t.string :ssghafd, :ssghnavn, :safdnavn
      t.integer :pkoen, :palder
      t.string :pnation
      t.datetime :dagsdato, :pfoedt
      t.index :journal_id
      t.index :journal_entry_id
      t.index :center_id
    end
    
    self.run_dynamic_migration(down = false)
  end

  def self.down
    # remove_index :export_journal_infos, :center_id
    # remove_index :export_journal_infos, :journal_entry_id
    # remove_index :export_journal_infos, :journal_id
    drop_table :export_journal_infos
    self.run_dynamic_migration(down = true)
  end 
  
  def self.run_dynamic_migration(down = true)
    surveys = Survey.all
    surveys.each do |s|
      gg = ExportMigrationGenerator.new(s)
      migration = gg.build_migration.join
      eval(migration)
      eval("CreateSurveyAnswerExport#{s.id}.#{down ? 'down' : 'up'}")
    end    
  end
end 

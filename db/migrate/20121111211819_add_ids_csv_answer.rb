class AddAltIdCsvSurveyAnswer < ActiveRecord::Migration
  def self.up
    add_column :journal_infos, :alt_id, :string
  end

  def self.down
    remove_column :journal_infos, :alt_id
  end
end


class AddIdsCsvAnswer < ActiveRecord::Migration
  def self.up
    add_column :csv_answers, :center_id, :int
    add_column :csv_answers, :team_id, :int
  end

  def self.down
    remove_column :csv_answers, :team_id
    remove_column :csv_answers, :center_id
  end
  
  def self.update
    CsvAnswer.find_in_batches do |csv_answers| 
      csv_answers.each do |csva| 
        if csva.journal_id.nil?
          puts "csva: #{csva.inspect}" if csva.journal_entry
          next
        end
        if csva.journal
          csva.center_id = csva.journal.parent.center_id 
          csva.team_id = csva.journal.parent_id if csva.journal.parent_id
        end
      end
    end
  end
end
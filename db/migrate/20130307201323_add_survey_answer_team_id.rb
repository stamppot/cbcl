class AddSurveyAnswerTeamId < ActiveRecord::Migration
  def self.up
    # add_column :survey_answers, :team_id, :int
    add_column :survey_answers, :alt_id, :string
  end

  def self.down
    # remove_column :survey_answers, :team_id
    remove_column :survey_answers, :alt_id
  end
  
  def update_all
    SurveyAnswer.find_each(:batch_size => 500) do |sa|
      if sa.journal.parent && sa.journal.parent.is_a?(Team)
        sa.team = sa.journal.parent
        puts "sa.team_id: #{sa.team_id}"
        sa.save
      end
    end
  end
  
  def update_alt_ids
    SurveyAnswer.find_each(:batch_size => 500) do |sa|
      sa.alt_id = sa.journal.person_info.alt_id
      sa.save
    end
  end
end
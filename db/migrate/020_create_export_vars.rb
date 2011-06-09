class CreateExportVars < ActiveRecord::Migration

  def self.up
    surveys = Survey.all.inject({}) { |h, s| h[s.id] = s.prefix; h } 
    variables = Variable.all.group_by {|v| surveys[v.survey_id] }
    create_table :export_journal_infos do |t|
      t.integer :journal_id, :limit => 3
      t.string  :ssghafd, :limit => 40
      t.string  :ssghnavn, :limit => 40
      t.string  :safdnavn, :limit => 40
      t.string  :pid, :limit => 12
      t.integer :pkoen, :palder, :limit => 1
      t.integer :pkoen_datatype, :palder_datatype
      t.string  :pnation, :limit => 30
      t.integer :pnation_datatype, :limit => 1
      t.date    :dagsdato, :pfoedt
      t.integer :dagsdato_datatype, :limit => 1
      t.integer :pfoedt_datatype, :limit => 1
    end
    add_index :export_journal_infos, :journal_id
    
    variables.each do |survey_prefix, vars|
      create_table "export_variables_survey_#{survey_prefix}" do |t|
        t.integer :journal_id, :limit => 3
        vars.each do |var|
          if var.datatype == "Numeric"
            t.integer var.var, :limit => 1
          else
            t.string var.var, :limit => 255
          end
          t.integer "#{var.var}_datatype", :limit => 1
        end
      end
      add_index "export_variables_survey_#{survey_prefix}", :journal_id
    end
  end

  def self.down
    surveys = Survey.all.map(&:prefix).each do |survey_prefix|
      drop_table "export_variables_survey_#{survey_prefix}"
    end
    drop_table :export_journal_infos
  end

end

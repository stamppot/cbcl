class AddSurveyPrefix < ActiveRecord::Migration
  def self.up
    add_column :surveys, :prefix, :string, :length => 8
  end

  def self.down
    remove_column :surveys, :prefix
  end
end

def prefix(id)
    pre = case id
    when 1 then "cc"  # cbcl 1,5-5 # change
    when 2 then "ccy" # CBCL 6-16
    when 3 then "ct"  # CTRF pædagog 1,5-5
    when 4 then "tt"  # TRF lærer 6-16
    when 5 then "ycy" # YSR 6-16
    end
    return pre
  end
  
def update_all
  Survey.find_each do |s|
    puts "hello #{s.id}"
    s.prefix = prefix(s.id)
    puts "s.prefix: #{s.prefix}"
    s.save
  end
end
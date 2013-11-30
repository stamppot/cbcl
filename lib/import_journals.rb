require 'rubygems'
require 'fastercsv'

class ImportJournals # AddJournalsFromCsv

    # when 1 then "cc"  # cbcl 1,5-5 # change
    # when 2 then "ccy" # CBCL 6-16
    # when 3 then "ct"  # CTRF pædagog 1,5-5
    # when 4 then "tt"  # TRF lærer 6-16
    # when 5 then "ycy" # YSR 6-16
    
    def initialize
    	puts "update(file, [survey_ids], team_id, do_save)"
    end

	def update(file, survey_ids, team_id, do_save = false)
		surveys = Survey.find(survey_ids)
		group = Group.find(team_id)
		center = group.center

		FasterCSV.foreach(file, :headers => true, :col_sep => ";", :row_sep => :auto) do |row|
			puts "Row: #{row}"
			next if row.blank?

			alt_id = row["alt_id"] || row["Graviditetsid"]
			b = row["birthdate"]
			journal_name = row["journalnavn"] || row["Bnavn"]
			parent_name = row["Mnavn"]
			parent_mail = row["Email"]
			sex = row["gender"]
			sex = sex == "d" || sex == "M" || sex == "1" || sex == "Pige" && 1 || 2

			puts "#{journal_name}: #{alt_id} #{b}"
			# next

			journal = Journal.find_by_title(journal_name)

			if b.blank?
				puts "ERROR: no birthdate: #{row}"
				next
			end

			birthdate = get_date(b)

			puts "birthdate: #{birthdate}"
			args = {
				:title => journal_name, :group_id => group.id, :center_id => group.center_id,
				:birthdate => birthdate, :parent_email => parent_mail, :title => journal_name,
				:parent_name => parent_name, :alt_id => alt_id, :nationality => "Dansk", :sex => sex
			}

			if !journal
				args[:code] = center.next_journal_code
				journal = Journal.new(args)
				puts journal.errors.inspect if !journal.valid?
				if do_save
					journal.save
					puts "Saved journal: #{journal.id}  #{journal.title}"
				end
			end
			
			add_surveys_and_entries(journal, surveys, do_save)
				
		end
	end

	def add_surveys_and_entries(journal, surveys = [], do_save = false)
		if surveys.any?
			if journal.journal_entries.any? # add extra surveys
				je_surveys = journal.journal_entries.map &:survey
				add_surveys = surveys - je_surveys
				puts "surveys: #{add_surveys.map &:inspect}"
				journal.create_journal_entries(add_surveys) if do_save
			elsif !journal.journal_entries.any?
				journal.create_journal_entries(surveys) if do_save
			end
		end
	end

	def get_date(d)
		# d = d.gsub("/", "-") if d.include? "/"
		i = d.index "-"
		if d.length == 5    # dmmyy and ddmmyy
			d = "0#{d}"
		end

		if d.length == 6    # ddmmyy
			y = d[4..5].to_i
			m = d[2..3].to_i
			d = d[0..1].to_i
			puts "ddmmyy #{d}-#{m}-#{y}"
			return Date.new(y,m,d)
		elsif d.length == 8 # dd-mm-yy
			puts "d.length == 8: #{d}"
			return Date.new(2000 + b[4..5].to_i, b[2..3].to_i, b[0..1].to_i)
		elsif i == 4 # yyyy-mm-dd
			y = d[0..3].to_i
			m = d[5..6].to_i
			d = d[8..9].to_i
			puts "y-m-d #{y}-#{m}-#{d}"
			return Date.new(y,m,d)
		elsif d.length == 10 && d[4] == "-" # yyyy-mm-dd
			y = d[0..3].to_i
			m = d[5..6].to_i
			d = d[8..9].to_i
			return Date.new(y,m,d)
		else 	  # dd-mm-yyyy 
			y = d[6..9].to_i
			m = d[3..4].to_i
			d = d[0..1].to_i
			puts "d-m-y #{y}-#{m}-#{d}"
			return Date.new(y,m,d)
		end
	end
end
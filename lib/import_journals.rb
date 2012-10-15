require 'rubygems'
require 'fastercsv'

class AddJournalsFromCsv

	# @csv_file = ""

	# def load_file(file)
	# 	File.open(file).each
	# end

	# def parse_file(file, survey_ids, group_id)
	# 	raise Exception if survey_ids.nil?
	# 	journals = []

	# 	group = Group.find(group_id)

	# 	FasterCSV.foreach(file, :headers => true, :col_sep => ";", :row_sep => :auto) do |row|
	# 		puts "Row: #{row}"
	# 		next if row.blank?

	# 		alt_id = row["alt_id"]
	# 		b = row["birthdate"]
	# 		journal_name = row["journalnavn"]
	# 		parent_name = row["Mnavn"] || ""
	# 		parent_mail = row["Email"] || ""
	# 		gender = row["gender"]
	# 		gender = 1 if gender == "d"
	# 		gender = 2 if gender == "p"

	# 		journal = Journal.find_by_title(journal_name, :conditions => ['parent_id = ?', group_id])
	# 		if journal



	# 		surveys = [1,3]

	# 		# does not read gender

	# 		next if b.blank?
	# 		birthdate = Date.new(2000 + b[4..5].to_i, b[2..3].to_i, b[0..1].to_i)

	# 		person_info = {:birthdate => birthdate, :parent_email => parent_mail, :name => journal_name,
	# 			:parent_name => parent_name, :alt_id => alt_id, :nationality => "Dansk" }
	# 		args = {:title => journal_name, :parent_id => group_id, :center_id => group.center_id}
	# 		args[:code] = group.center.next_journal_code
	# 		journal = Journal.new(args)
	# 		journal.build_person_info(person_info)
	# 		journals << journal

	# 		if journal.valid? && journal.person_info.valid?
	# 			journal.save
	# 			journal.person_info.save
	# 		else
	# 			puts "person_info: #{journal.person_info.errors.inspect}"
	# 			puts "journal: #{journal.errors.inspect}"
	# 		end
	# 		puts "journal: #{journal.inspect}  #{journal.person_info.inspect} Valid: #{journal.valid?} #{journal.errors.inspect}"
	# 	end

	# 	journals.each do |j|
	# 		puts "Journal: #{j.inspect}"
	# 	end
	# end

	def update(file, survey_ids, center_id = 1)
		surveys = Survey.find(survey_ids)
		group = Group.find(center_id)

		FasterCSV.foreach(file, :headers => true, :col_sep => ";", :row_sep => :auto) do |row|
			puts "Row: #{row}"
			next if row.blank?

			alt_id = row["alt_id"]
			b = row["birthdate"]
			journal_name = row["journalnavn"]
			parent_name = row["Mnavn"]
			parent_mail = row["Email"]
			sex = row["gender"]
			sex = 1 if sex == "d"
			sex = 2 if sex == "p"

			puts "#{journal_name}: #{alt_id}"
			# next

			journal = Journal.find_by_title(journal_name)

			next if b.blank?
			birthdate = Date.new(2000 + b[4..5].to_i, b[2..3].to_i, b[0..1].to_i)

			person_info = {:birthdate => birthdate, :parent_email => parent_mail, :name => journal_name,
				:parent_name => parent_name, :alt_id => alt_id, :nationality => "Dansk" }
			args = {:title => journal_name, :parent_id => group.id, :center_id => group.center_id}
			
			if !journal
				args[:code] = center.next_journal_code
				journal = Journal.new(args)
				journal.save
			end
			
			if !journal.person_info
				journal.build_person_info(person_info)
				journal.person_info.save if journal.person_info.valid?
			else
				journal.person_info.update_attributes(person_info)
			end
			
			if !journal.journal_entries.any?
				journal.create_journal_entries(surveys)
			else
				next
			end

			if journal.person_info.valid?
				# journal.save
				journal.person_info.save
				puts "#{journal.person_info.inspect}"
			else
				puts "person_info: #{journal.person_info.errors.inspect}"
				puts "journal: #{journal.errors.inspect}"
			end
			puts "journal: #{journal.inspect}  #{journal.person_info.inspect} Valid: #{journal.valid?} #{journal.errors.inspect}"
		end
	end
end

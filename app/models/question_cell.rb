class QuestionCell < ActiveRecord::Base
	belongs_to :question
	#serialize :question_items, Array
	serialize :preferences
	attr_accessor :value, :number, :question_items  # must be accessed through self.question_items
	attr_accessor :question_text, :options

	named_scope :ratings, :conditions => ['type = ?', 'Rating']
	named_scope :answerable, :conditions => ['type IN (?)', ['Rating', 'Checkbox', 'ListItemComment', 'SelectOption', 'Textbox']]  # and ListItem???? TODO: check if this can be answered, otherwise answerable part should be extracted to other type
	named_scope :unanswerable, :conditions => ['type not IN (?)', ['Rating', 'Checkbox', 'ListItemComment', 'ListItem', 'SelectOption', 'Textbox']]

	def row_data
		self.answer_text if question_text.nil?
		data = {:item => self.answer_item, :text => self.question_text, :question => self.question.number }
		data[:score] = item_options.size > 1 && item_options_text || "text"
		data
	end
	
	def datatype # || self.type == "Checkbox"  - for now only ratings are numeric values
		self.is_a?(Rating) && :numeric || :string
	end
			
	def cell_same_row
		cells = self.question.question_cells(:conditions => ['col != ? AND row = ?', self.col, self.row])
		cell = cells.first if cells.any?
	end

	def mix(other_cell)
		if self.answerable?
			self.question_text = other_cell.item_options.first[:text]
		else
			self.question_text = self.item_options.first[:text]
			self.options = other_cell.item_options_text
		end
		self
	end
	# private :mix, :cell_same_row
	
	def value_to_text
		self.question_items.map { |item| [item.value.blank? && item.text || item.value, item.position] }
	end
	
	def answer_text
		other_cell = cell_same_row
		mix(other_cell) if other_cell
	end
	
	def answerable?
		# or check if item_options returns more than one element array
		['Rating', 'Checkbox', 'ListItemComment', 'SelectOption', 'Textbox'].include? self.class.to_s
	end
	
	# initialize self.items to array of QuestionItems
	def question_items
		@question_items = [] if @question_items.nil?
		if !@question_items.empty?
			return @question_items
		elsif !self.items.nil? and !self.items.empty?
			items.split("\#\#\#").each_with_index do |item, i|
				fields = item.split("::")
				q_item = QuestionItem.new
				q_item.qtype = (fields[0].nil? ? "" : fields[0])
				q_item.value = (fields[1].nil? ? "" : fields[1])
				q_item.text  = (fields[2].nil? ? "" : fields[2])
				q_item.position = i+1
				@question_items << q_item
			end
		end
		return @question_items
	end

	# create question_item objects from "items"=>[["radio", 0], ["radio", 1]]
	def create_question_items(items)
		question_items = []
		items.each_with_index do |item, i|  # item == ["option", "value"]  # sort by 2nd in array, which is item value
			@q_item = QuestionItem.new
			@q_item.qtype = item.first
			@q_item.text  = item[1]  # second item is value
			# @q_item.value = item[1]
			@q_item.position = i+1   #from zero-index to 1-indexed
			if item.size == 3 and @q_item.qtype.downcase =~ /option|radio|checkbox|checkboxaccess/
				@q_item.value = item.last
			end
			question_items << @q_item
		end
		return question_items
	end

	# "items"=>[["radio", 0], ["radio", 1]]
	def add_question_items(items)   #params is hash of type => value
		new_q_items = create_question_items(items)
		add_q_items(new_q_items)
	end

	def add_switch_source(source)
		self.preferences ||= Hash.new
		if self.preferences[:switch].nil?
			self.preferences[:switch] = [source.to_s]
		else
			self.preferences[:switch] << source.to_s
		end
	end

	# returns nil if nothing is removed
	def remove_switch_source(source)
		self.preferences ||= Hash.new
		if self.preferences[:switch].nil?
			return nil
		else
			return self.preferences[:switch].delete(source.to_s)
		end
	end

	# sets one switch source, removes others if present
	def set_switch_source(source)
		self.preferences ||= Hash.new
		self.preferences[:switch] = [source.to_s]
	end

	# switches are an array of identifiers
	def switch_source(options = {})
		if options[:disabled]
			""
		elsif preferences && preferences[:switch]
			preferences[:switch].collect { |s| "switch-#{s}" }.join(" ")
		else
			""
		end
	end

	# sets one switch target, removes others if present
	# true == onstate
	# false == offstate
	def set_switch_target(target, state)
		self.preferences ||= Hash.new
		self.preferences[:targets] = [ {:target => target.to_s, :state => (state ? "onstate" : "offstate")} ]
	end

	# targets are a hash of target, state. A cell can have multiple targets
	# preference[:target] => [ {:target => "a", true}, {:target => "b", false} ]
	# true == onstate, false == offstate
	# if exists, switch is replaced
	def add_switch_target(target, state)
		self.preferences ||= Hash.new
		if self.preferences[:targets].nil?
			self.preferences[:targets] = [{ :target => target.to_s, :state => (state ? "onstate" : "offstate")}]
		else
			self.remove_switch_target(target)
			self.preferences[:targets] << { :target => target.to_s, :state => (state ? "onstate" : "offstate")}
		end
	end

	# returns nil if nothing is removed
	def remove_switch_target(target)
		self.preferences ||= Hash.new
		if self.preferences[:targets].nil?
			nil
		else
			self.preferences[:targets].delete_if { |elem| elem[:target] == (target.to_s) }
		end
	end

	# to be deprecated by validation
	def set_required(boolean)
		self.preferences ||= Hash.new
		self.preferences[:required] = boolean
	end

	def required?
		self.preferences && self.preferences[:required]
	end
	alias :required :required?

	def set_default_value=(value)
		self.preferences ||= Hash.new
		self.preferences[:value] = value
	end

	def default_value
		self.preferences && self.preferences[:value]
	end

	def set_validation(validation)
		self.preferences ||= Hash.new
		self.preferences[:validation] = validation
	end

	def validation
		self.preferences && self.preferences[:validation]
	end

	def clear_prefs!
		preferences = nil
		self.save
	end

	def switch_target(options = {})
		if options[:disabled]
			""
		elsif preferences && preferences[:targets]
			preferences[:targets].collect { |t| "#{t[:state]}-#{t[:target]}" }.join(" ")
		else
			""
		end
	end

	def item_options
		options = self.question_items.map { |item| { :text => item.text, :value => item.value } }
	end

	def item_options_text
		options = self.question_items.map { |item| "#{item.value.blank? && 'text' || item.value} = #{item.text}" }
	end

	def to_s
		info = ""
		items = ""
		info << "qtype: " << qtype.to_s << "\n"
		info << "row: " << row.to_s << "\n"
		info << "\t"*(col-1) << "col: " << col.to_s << "\n"
		self.question_items.each do |item|
			items += item.qtype.to_s + ": " + item.value.to_s + "\n"
		end
		return info
	end

  def outer_span(last = false)
    span = "span-7" if col == 1
    span = "span-8" if col != 1
    span << " last" if last
    span
  end
  
	def to_html(options = {})
		onclick  = options[:onclick]
		options[:outer_span] = outer_span
		
    # puts "OPTIONS: #{options.inspect}  id_and_class: #{id_and_class(options)}"
		id_class = id_and_class(options)
    id_class.gsub!(/onstate-(.)/, '')
    id_class.gsub!(/offstate-(.)/, '')
    # puts "OPT: #{id_class}"
    
    "<div #{onclick} #{id_class} >#{create_form(options)}</div>"
	end

	def to_fast_input_html(options = {})
		"<div #{id_and_class(options)} >#{fast_input_form(options)}</div>"
		# fast_input_form(options)
	end

	# comparison based on row first, then column
	def <=>(other)
		if self.row == other.row
			self.col <=> other.col
		else
			self.row <=> other.row
		end
	end

	def eql_cell?(other)
		!other.nil? && (self.row == other.row) && (self.col == other.col)
	end

	# sets id and class for td cells
	def id_and_class(options = {}) # change to {}
		ids = ["id='td_#{self.cell_id(options[:number])}' class='#{self.class_name} #{options[:outer_span]}"]
    puts "options: #{options.inspect}" if self.is_a? Description
		ids << " " << options[:target] if options[:target]
		(ids << "'").join
		# end
	end

	def cell_id(no = self.question.number)
		no ||= self.question.number
		return "q#{no}_#{row}_#{col}"
	end

	# generates class names used for layout. E.g. for items of type desc, it adds lab1 etc.
	def class_name
		name = self.class.to_s.downcase
		if self.instance_of?(Description) or self.instance_of?(Rating)
			name += self.question_items.size.to_s
			item = self.question_items.collect { |item| item.text.length unless item.text.nil? }.compact.max
			name << case item
			when (1..1): "lab"    # labels 0 1 2 etc
			when (2..4): "lab1"    # nej, ja, etc
			when (5..8): "lab2"    # middel, daarligt, bedre etc
			when (9..15): "lab3"   # laengere
			when (16..40): "lab4"  # lange fx mindre end gennemsnit etc
			else ""
			end
		end
		name
	end

	def div_item(html, type, id = nil)
		#content_tag("div", html, { :class => type } )
		id_attr = id.blank? ? "" : "id='#{id}'"
		"<div #{id_attr} class='#{type}'>#{html}</div>"
	end

	def span_item(html, type, id = nil)
		id_attr = id.blank? ? "" : "id='#{id}'"
		"<span #{id_attr} class='#{type}'>#{html}</span>"
	end

	def span_item(html, type)
		#content_tag("div", html, { :class => type } )
		"<span class='#{type}'>#{html}</span>"
	end

	def form_template(value = nil, disabled = false, show_all = true)
		form = self.question_items.collect { |item| (item.text.nil? ? "" : item.text) + ": " + (item.value.nil? ? "" : item.value) }
		form.join
	end

	def create_form(options = {})
		# options[:value]    = options[:value]
		options[:disabled] = options[:disabled] ? true : false
		options[:show_all] = options[:show_all] && true || false
		options[:fast]     = options[:fast] ? true : false
		options[:edit]     = options[:action] == "edit"
		options[:print]    = options[:action] == "print"
		options[:action]   = options[:action]
    puts "options: #{options.inspect}" if self.is_a? Questiontext
		self.form_template(options)
	end

	def fast_input_form(options = {}, value = nil)
		options[:disabled] = false
		options[:show_all] = false
		options[:number]   ||= self.question.number.to_s
		options[:edit]     = options[:action] == "edit"
		options[:print]    = options[:action] == "print"
		options[:action]   = options[:action]
		self.create_form(options)
	end

	def edit_form
		self.create_form
	end

	def svar_item
		if self.answer_item.nil? or self.answer_item.empty?
			""
		elsif self.answer_item.match(/\d+([a-z]+)/)  # cut off number prefix (fx 1.)
			"\t" + $1 + ". "
		else self.answer_item + ". "
		end
	end

	def values
		vals = self.question_items.collect { |item| item.value.to_s unless item.value.empty? }.compact.sort
		return vals
	end

	def text_values
		self.question_items.collect { |item| "#{item.text = item.value}" }.compact.sort
	end

	# if two values are 'overlapping strings' such as 8 and 88, then exactlyOneOf validation is returned
	# values are string-sorted
	def validation_type
		values = self.question_items.map {|item| item.value.to_s}.sort # string sort
		b = []
		0.upto(values.length-2) do |i|
			b << true if(values[i+1].include?(values[i]))
		end
		if b.length > 0
			"exactlyoneof"
		else
			"oneof"
		end
	end

	# insert javascript piece to check value is one of valid values
	# cannot be named validate, then it's called automatically
	def add_validation(options = {})
		no = options[:number] || self.question.number.to_s 
		#validation = options[:validate] || ""
		#callback = options[:callback] || nil

		#values = @question_items.collect { |item| item.value.to_s unless item.value.empty? }.sort
		errormsg = "Ugyldig værdi. Brug " << self.values.join(", ")
		script = "\t\t<script type='text/javascript'>" <<
		case self.validation_type
		when "oneof": "\tValidation.add('#{self.cell_id(no)}', '#{errormsg}', { oneOf : #{self.values.inspect} });\n"
		when "exactlyoneof":
			"\tValidation.add('#{self.cell_id(no)}', '#{errormsg}', { exactlyOneOf : #{self.values.inspect} } );"
			# todo  how to check value of checkbox
		when "checkbox" : "\tValidation.add('#{self.cell_id(no)}', '#{errormsg}', { oneOf : '[\"0\",\"1\"]' });\n"
		else
			"\tValidation.add('#{self.cell_id(no)}', '#{errormsg}', { oneOf : #{self.values.inspect} } );"
			# "\tValidation.add('#{self.cell_id}', '#{errormsg}', { oneOf : #{self.values.inspect});\n"
		end
		script << "\t\t</script>"
	end

	def to_xml2
		xml = []
		xml << "<question_cell id='#{self.id.to_s}' >"
		xml << "  <type>#{self.type.to_s}</type>"
		xml << "  <col>#{self.col.to_s}</col>"
		xml << "  <row>#{self.row.to_s}</row>"
		xml << "  <item>#{self.answer_item}</item>"
		xml << "  <question_items>"
		xml << self.question_items.collect { |question_item| question_item.to_xml }
		xml << "  </question_items>"
		xml << "</question_cell>"
	end

	private

	def after_initialize 
		self.preferences ||= Hash.new 
	end

	# append directly to items field
	def add_q_items(question_items)
		self.items = "" if self.items.nil? or self.items.empty?
		question_items.each do |item| 
			if self.items.empty?
				self.items += item.to_db
			else
				self.items += "###" + item.to_db
			end
		end
		# return question_items.inspect
		#self.save
		return self.question_items     # return new items to enable chaining
	end

end

class Questiontext < QuestionCell
  
  def outer_span(last = false)
    span = "6"
    span.succ! unless self.col == 1    # span += 1 if row == 1
    span = "span-#{span}"
    span << " last" if last # self.col == self.question.columns
    span
  end
  
  def inner_span
    outer_span
  end
  
	def to_fast_input_html(options = {})
    # options[:span] = span_class
		"<div #{id_and_class(options)} >#{form_template(options)}</div>"
	end

	def form_template(options = {}) #value = nil, disabled = false, show_all = true)
		newform = ""
		answer_item = (self.answer_item.nil? or (self.answer_item =~ /\d+([a-z]+)/).nil?) ?  "" : "\t" + $1 + ". "
		
		self.question_items.each do |item|
			newform = if item.position==1
				div_item( answer_item + item.text, "#{inner_span} itemquestiontext #{switch_target(options)}".rstrip)
			else
				div_item( item.text, "#{inner_span} itemquestiontext #{switch_target(options)}".rstrip)
			end
		end
		newform
	end

	# def fast_input_form(options = {}, value = nil)
	#   options = {:value => value}
	#   form_template(options)
	# end

	# cell with inline editing
	def edit_form
		newform = ""
		item_text = question_items.first.text #
		answer_item = (self.answer_item.nil? or (self.answer_item =~ /\d+([a-z]+)/).nil?) ?  "" : "\t" + $1 + ". "
		self.question_items.each do |item|
			newform = if item.position==1
				div_item( answer_item + item.text, "itemquestiontext span-9")
			else
				div_item( item_text, "itemquestiontext span-9")
			end
		end
		newform
	end

end

class Information < QuestionCell

	def to_html(options = {})
		"<div colspan='3' id='td_#{cell_id(options[:number])}' class='#{class_name} information span-23 last' >#{question_items.first.text}</div>"
	end

	def to_fast_input_html(options = {})
		to_html(options)
	end

	def form_template(options = {})
		div_item(question_items.first.text, "iteminformation")
	end

	def fast_input_form(options = {}, value = nil)
		form_template()
	end

	# cell with inline editing Cdisabled!)
	def edit_form
		item_text = question_items.first.text #in_place_editor_field :question_cell, :items, {}, :rows => 3
		div_item(item_text, "iteminformation")
	end

end

class Placeholder < QuestionCell

  def outer_span
    "span-4"
  end
  
	def form_template(options = {})
		div_item(question_items.first.value + "&nbsp;", "span-4 itemplaceholder")
	end

	def fast_input_form(options = {}, value = nil)
		form_template()
	end
end

class ListItem < QuestionCell

  def to_html(options = {})
    options[:target] = switch_target(options) unless switch_target.empty?
    super(options)
  end
  
  def to_html(options = {})
    # onclick    = options[:onclick]
    switch_off = options[:switch_off]
    class_switch = switch_target(options) unless switch_off
    class_names  = class_name <<
    ((class_switch.blank? or !switch_off.blank?) ? " #{outer_span}" : " #{class_switch} #{outer_span}" )
  
    options[:outer_span] = outer_span(options[:last])
    id_class = id_and_class(options)
      
    klass_name = class_name
    fast = options[:fast] ? true : false
    klass_name << (fast && "" || " " + switch_target(options))
  
    "<div id='td_#{cell_id(options[:number])}' class='#{klass_name}'>#{form_template(options)}</div>"
  end
	

	def to_fast_input_html(options = {})
		options[:target] = switch_target(options) unless switch_target.empty?
		super(options)
	end

  def outer_span(last = false)
    span = if col == 2 and self.question.columns == 2
      "span-18"
    else
      "span-6"
    end
    span << " last" if last
    span
  end
  
  def inner_span
    outer_span # "span-6"
  end
  
	def form_template(options = {})  # value = nil, disabled = false, show_all = true, edit = false)
		disabled = options[:disabled] ? "disabled" : nil
		show_all = options[:show_all].nil? || options[:show_all]
		fast     = options[:fast]
		edit     = options[:edit]
		no       = options[:number].to_s || self.question.number.to_s
		c_id     = cell_id(no)

		newform = []
		question_no = "Q" + no

		self.question_items.each_with_index do |item, i|
			item_text = edit ? item.text : item.text
			field = (i == 0 ? self.svar_item : "")# only show answer_item label in first item for cell with multiple list items
			has_no_text = item_text.blank?
			if(has_no_text)     # listitem without predefined text
				if(disabled)      # show answer value
					field << value
				else                        # show text field, possibly with value
          case options[:action]
			    when /print|show/ : 
			      field << (value || "")
			      newform << div_item(field, "listitemfield answer_textbox")
			    when /create|edit/ :
            field << "<textarea id='#{c_id}' class='textfield' name='#{question_no}[#{cell_id(no)}]' type='text' rows='1'>#{value}</textarea>"
            newform << div_item(field, "listitemfield")
          end
				end
			else  # with predefined text. show text in item (no input field)
        newform << div_item(field + item_text, "#{inner_span} listitemtext")
			end
		end
		# newform << "<input id='#{cell_id}_item' name='#{question_no}[#{cell}][item]' type='hidden' value='#{self.answer_item}' />" unless self.answer_item.nil?
		newform.join
	end

	def fast_input_form(options = {}, value = nil)
		options[:disabled] = false
		options[:show_all] = true
		form_template(options)
	end

	# cell with inline editing. Only works for listitems with contents (ie. not answerable)
	def edit_form
		options = { :disabled => false, :show_all => true, :edit => true}
		form_template(options)
	end

end


class SelectOption < QuestionCell

  def outer_span(last = false)
    span = "span-4"
    span = "span-6" if self.question.columns == 2 and col == 1
    span << " last" if last
    span
  end
  
  def inner_span
    outer_span
  end
  
	def to_html(options = {})
	  options[:outer_span] = outer_span
		options[:target] = switch_target(options) unless switch_target.empty? or options[:switch_off]
		super(options)
	end

	def to_fast_input_html(options = {})
		#options[:target] = switch_target(options) unless switch_target.empty?
		super(options)
	end

	def form_template(options = {})
		disabled      = options[:disabled] ? "disabled" : nil
		show_all      = options[:show_all].nil? || options[:show_all]
		#edit          = options[:edit] ? true : false
		no            = options[:number].to_s || self.question.number.to_s
		switch_off    = options[:switch_off]
		c_id          = cell_id(no)
		q_no          = "Q#{no}"
		do_validation = self.validation && self.validation || ""

		newform = []
		target = (!disabled and !switch_off) ? switch_target(options) : ""

		# create options array
		qitems = self.question_items.collect { |item| [item.qtype, item.value, item.text] }
		if qitems.first[0] == "listitem"
			label = qitems.shift
			newform << "<label for=#{c_id} class='selectlabel'>#{label.last || ""}</label><br>"
		end 
		sel_options = ["<option value=''>Vælg et svar</option>"]
		qitems.each do |option|
			sel_options << "<option value='#{option[1]}' "
			sel_options << "selected='selected'" if !value.nil? and option[1] == value
			sel_options << ">#{option[2]}</option>"
		end
		if disabled # and !value.nil?  # disabled means show answer
			# find text for this value answer
			answer_vals = qitems.detect { |item| item[1].to_s == value.to_s } # item array: index 1 -> value, index 2 -> værdi?
			newform >> (answer_vals && answer_vals[2] || (value == "0" && "ikke besvaret" || "ingen værdi"))
		else # 10-7 removed #{self.validation} before disabled
			newform << "<select id='#{c_id}' name='#{q_no}[#{c_id}]' #{disabled} >" + sel_options.join + "\n</select>"
		end
		newform << self.add_validation(options) unless disabled
		div_item(newform.join, "span-5 selectoption #{target}".rstrip)
	end

	def fast_input_form(options = {}, value = nil)
		disabled = options[:disabled] ? "disabled" : nil  # Disabled == show answer
		no       = options[:number] || self.question.number.to_s
		fast     = options[:fast] ? true : false
		c_id     = cell_id(no)
		question_no = "Q#{no}"

		answer_item = svar_item
		target = ""# switch_target(options) unless fast
		# 12-2-8 Decision: hurtig input har ingen required, tester kun for rette værdier. Eller alle skal være required
		req = self.required? ? "required" : ""

		newform = []
		# make validation here
		qitems = self.question_items.collect { |item| [item.qtype, item.value, item.text] }
		if qitems.first[0] != "option"  # Select options has label of type listitem
			label = qitems.shift
			target = ""
			newform << "<label for=#{question_no}_#{c_id} class='selectlabel#{target}'>#{label.last}</label>"
		end
		values = qitems.map { |item| item[1] }
		help = qitems.map { |item| (item[1] == item[2]) ? item[1] : "#{item[1]} = #{item[2]}" }.join("<br>")

		newform << div_item(answer_item + "<input id='#{c_id}' name='#{question_no}[#{c_id}]' class='selectoption #{req} #{c_id}' type='text' " +
		(self.value.nil? ? " >" : "value='#{self.value}' >"), "selectoption #{target}".rstrip) # << # removed />
		newform << help_div(c_id, help)  # TODO: fix values of help not shown for q7

		newform << self.add_validation(options) unless disabled
		newform.join
	end

	def help_div(cell_id, help_message)
		"&nbsp;&nbsp;&nbsp;<img src='/images/icon_comment.gif' class='help_icon' alt='Svarmuligheder' title='Vis svarmuligheder' onclick='Element.toggle(\"help_#{cell_id}\");' >" <<
		"<div id='help_#{cell_id}' style='display:none;'><div class='help_tip'>#{help_message}</div></div>"
	end

	def values  # valid values
		vals = self.question_items.collect { |item| item.value.to_s unless item.value.empty? }.compact.sort
		# vals << "9" unless vals.include? "9"
	end

	def add_validation(options = {}) # TODO: første skal indfyldes; fejlværdig (ikke udfyldt?)
		no = options[:number] || self.question.number.to_s 
		script = []
		if self.preferences # && self.preferences[:validation]
			errormsg = "Ugyldig værdi. Brug " << self.values.join(", ")
			script << "\t\t<script type='text/javascript'>"

			if self.preferences[:validation].respond_to? :size  # array
				script << "\nValidation.addAllThese([['#{self.cell_id(no)}', 'Værdi er ugyldig eller ikke udfyldt.', {\n"
				script << "  xOneOf : #{self.values.inspect},"
				script << "  oneOf : #{self.values.inspect},"
				validations = []
				self.preferences[:validation].each do |elem|  # array of tuples (hash-pairs)
					validations << elem.map { |k,v| "\n  #{k} : '#{v}'" }
				end
				script << validations.join(",")
				script << "\n}]]);\n"
			else
				script << "Validation.add('#{self.cell_id(no)}', '#{errormsg}', { xOneOf : #{self.values.inspect} } );"
			end        
			script << "\t\t</script>"
		end
		script.join
	end

end

class Checkbox < QuestionCell

  def outer_span
    "span-4"
  end
  
	def form_template(options = {}) # value = nil, disabled = false, show_all = true)
		disabled = options[:disabled] ? "disabled" : nil
		answer   = options[:answers]
		show_all = options[:show_all].nil? || options[:show_all] # show_all = options[:show_all].nil? ? true : false
		fast     = options[:fast] ? true : false
		edit     = options[:edit] ? true : false
		no       = options[:number].to_s || self.question.number.to_s 
		c_id     = cell_id(no)

		newform = []
		question_no = "Q" + no
		klass_name = "#{switch_target(options)} #{switch_source(options)}".strip
		klass_name = "class='#{klass_name}'" unless klass_name.empty?

		self.question_items.each do |item|
			label = "<label for='#{c_id}'>#{item.text}</label>"
			checkbox = "<input id='#{c_id}' name='#{question_no}[#{c_id}]' #{klass_name} type='checkbox' value='1' #{disabled} "
			checkbox += ((self.default_value || item.value).to_s == "1") ? "checked='checked' >" : ">" # removed />
			checkbox += "<input name='#{question_no}[#{c_id}]' type='hidden' value='0' >" # removed />
			newform << div_item(checkbox + label, "checkbox span-7")
		end
		newform.join
	end

	def fast_input_form(options = {})
		disabled = options[:disabled] ? "disabled" : nil
		show_all = options[:show_all].nil? || options[:show_all] # show_all = options[:show_all].nil? ? true : false
		fast     = options[:fast] ? true : false
		edit     = options[:edit] ? true : false
		no       = options[:number].to_s || self.question.number.to_s 
		c_id     = cell_id(no)

		newform = []
		question_no = "Q" + no
		klass_name = "#{switch_target(options)} #{switch_source(options)}".strip
		klass_name = "class='#{klass_name}'" unless klass_name.empty?

		self.question_items.each do |item|
			label = "<label for='#{c_id}'>#{item.text}</label>"
			checkbox = "<input id='#{c_id}' name='#{question_no}[#{c_id}]' #{klass_name} type='checkbox' value='1' #{disabled} "
			checkbox += ((value.nil? ? item.value.to_s : value.to_s) == "1") ? "checked='checked' />" : "/>"
			checkbox += "<input name='#{question_no}[#{c_id}]' type='hidden' value='0' >" # removed />
			newform << div_item(checkbox + label, "checkbox") << self.add_validation(:validate => "checkbox", :number => no)# + hidden_fields
		end
		newform.join
	end
	# form_template(options) << self.add_validation(:validate => "checkbox")
	# end

	def validation_type
		"checkbox"
	end

	def values
		vals = ["0", "1"]
	end
end


class ListItemComment < QuestionCell

	def to_html(options = {})
		options[:target] = switch_target(options) unless switch_target.empty? or options[:switch_off]
		super(options)
	end

  def outer_span
    "span-6"
  end
  
	def to_fast_input_html(options = {})
		#options[:target] = switch_target(options) unless switch_target.empty?
		super(options)
	end

	def fast_input_form(options = {}, value = nil)
		no = options[:number] || self.question.number.to_s 
		options[:disabled] = true
		options[:show_all] = true
		options[:number] = no
		options[:fast] = true
		options[:hidden] = true
		c_id     = cell_id(no)

		comment_box = "<a href='#' onclick='return toggleComment(\"#{c_id}\");' >" <<
		"<img src='/images/icon_comment.gif' border=0 title='Kommentar' alt='kommentar' class='comment' >" << # removed />
		"</a>" unless options[:answers]
		form = form_template(options) << comment_box.to_s
	end

	def form_template(options = {}) # value = nil, disabled = false, show_all = true)
		disabled   = options[:disabled] ? "disabled" : nil
		answer     = options[:answers] ? true : false
		show_all   = options[:show_all].nil? || options[:show_all] # show_all = options[:show_all].nil? ? true : false
		fast       = options[:fast] || false
		edit       = options[:edit] || false
		no         = options[:number].to_s || self.question.number.to_s 
		switch_off = options[:switch_off]

		c_id     = cell_id(no)
		newform = []
		question_no = "Q" + no
		answer_item = self.svar_item
		answer_item_set = false
		target = (fast or switch_off) ? "" : switch_target(options)
    span = "span-7"
    
		self.question_items.each do |item|
		  listitem_without_predefined_text = item.text.nil? || item.text.empty?
		  case item.qtype
				# enable/disable button
			when "textbox": newform << 
				if (listitem_without_predefined_text)
					input_or_answer = answer ?
					  (self.value.blank? ? "" : "<div id='#{c_id}' class='answer_comment'>#{self.value}</div>") :
					  "<textarea id='#{c_id}' name='#{question_no}[#{c_id}]' class='comment' cols='35' rows='5' #{disabled ? ' disabled style="display:none;"' : ''}>#{self.value}</textarea>"
					div_item((answer_item_set ? "" : answer_item) + input_or_answer,
					"itemtextbox #{span} #{target}".rstrip)
				else div_item((answer_item_set ? "" : answer_item) + item.text, "listitemtext #{span} #{target}".rstrip)
				end
			when "listitem": 
        answer_item_set = true if self.col == 1
			  newform <<
				if (listitem_without_predefined_text)
					div_item(((answer_item_set && self.col > 2) ? "" : answer_item) + 
          # "<input id='#{c_id}' name='#{question_no}[#{c_id}]' type='text' value='#{item.value}' size='20' >#{self.value}</input>", "listitemfield")
					"<textarea id='#{c_id}' name='#{question_no}[#{c_id}]' class='textfield' type='text' rows='1' value='#{item.value}'>#{self.value}</textarea>", "listitemfield #{span}")
				else div_item(((answer_item_set || self.col > 2) ? "" : answer_item) + item.text, "listitemtext #{span} #{target}".strip)
				end
				answer_item_set = true;
			end
		end
		newform.join
	end
end

class Rating < QuestionCell

	def to_html(options = {})  # :fast => true, use fast_input_form
		onclick    = options[:onclick]
		switch_off = options[:switch_off]
		
		# todo switch target
		class_switch = switch_target(options) unless switch_off
		class_names  = class_name + ((class_switch.blank? or switch_off) ? " #{outer_span}" : " #{class_switch} #{outer_span}" )

		klass_name = "class='#{class_names}'".rstrip unless class_name.blank?
    # span = "span-6"
    # puts "class_name: #{class_name}" if question.number == 7
		colspan = "colspan='3'" if class_name == "rating4"
		"<div #{colspan} id='td_#{cell_id(options[:number])}' #{onclick} #{klass_name}>#{form_template(options)}</div>"
	end

	def to_fast_input_html(options = {})  # :fast => true, use fast_input_form
		# todo switch target   # no switches in fast_input
		klass_name = "class='#{class_name}'".rstrip unless class_name.empty?
		"<div id='td_#{cell_id(options[:number])}' #{klass_name}>#{fast_input_form(options)}</div>"
	end

  def outer_span(last = false)
    span = case class_name
    when "rating3lab": "span-4"
    when "rating2lab1": "span-3"
    when "rating3lab2": "span-4"
    when "rating3lab3": "span-3"
    when "rating3lab4": "span-6"
    when "rating5lab4": "span-6"
    when "rating4": "span-12"
    when "rating3": "span-9"
    when "rating7": "span-16"
    # when "rating7": "span-16"
    else ""
    end
    span << " last" if last
    span
  end
  
  def inner_span(last = false)
    span = case class_name
    when "rating3lab": "span-1"
    when "rating2lab1": "span-2"
    when "rating3lab2": "span-3"
    when "rating3lab3": "span-4"
    when "rating3lab4": "span-4"
    when "rating5lab4": "span-4"
    when "rating4": "span-3"
    when "rating5": "span-3"
    when "rating3": "span-3"
    when "rating7": "span-2_5"
    # when "rating7": "span-16"
    else
      "span-#{9 / self.question_items.size}"
    end
    span << " last" if last
    span
  end
  
	def create_form_disabled
	end

	# if given value, set as checked, or already chosen value
	def form_template(options = {}) # value = nil, disabled = false, show_all = true)
		disabled = options[:disabled] ? true : false
		answer   = options[:answers]
		show_all = options[:show_all] && true || false
		fast     = options[:fast] ? true : false
		edit     = options[:edit] ? true : false
		onclick  = options[:onclick] || "onclick='toggleRadio(this)'"
		no       = options[:number].to_s || self.question.number.to_s
		switch_off = options[:switch_off]
		c_id     = cell_id(no)

		newform = []
		question_no = "Q#{no}" # self.question.number.to_s
		checked = false

		q_items = self.question_items
    # span = inner_span() "span-#{9 / q_items.size}"
    #     # span = span_class unless span_class.blank?
    #     span = "span-4" if class_name == "rating5lab4"
    # span = "span-1" if class_name == "rating3lab"
    # span = "span-3" if class_name == "rating3lab2"
    # span = "span-4" if class_name == "rating3lab3"
    # span = "span-2" if class_name == "rating2lab1"
		
		q_items.each_with_index do |item, i|
		  span = inner_span(q_items.size-1 == i)
			switch_src = (i > 0) ? switch_source(options) : "" # set switch on positive answers; 0 is 'no'
      # span << " last" if i == q_items.size-1
  		
			if show_all
				checked = (value == item.value ? 'checked="checked"' : nil)
				switch  = ((switch_src.blank? || switch_off) ? nil : "class='rating #{switch_src}'")
				disable = (disabled ? "disabled" : nil)
				# id = "id='#{c_id.strip}_#{i}'"
				newform << div_item(
				"<input id='#{c_id}_#{i}' #{onclick} name='#{question_no}[#{c_id}]' type='radio' value='#{item.value}' #{switch} #{disable} #{checked} >" + # removed />
				(item.text.blank? ? "" : "<label class='radiolabel' for='#{c_id}_#{i}'>#{item.text}</label>"), "radio #{span} #{(i+1)==q_items.length ? self.validation : ""}".rstrip)
			else # show only answers, not all radiobuttons, disabled
				newform << if value == item.value    # show checked radiobutton
          span_item("<input id='#{c_id}_#{i}' name='#{question_no}[#{c_id}]' type='radio' value='#{item.value}' checked='checked'" +
          					(disabled ? " disabled" : "") + " />" +
          					(item.text.empty? ? "" : "<label class='radiolabel' for='#{c_id}_#{i}'>#{item.text}</label>"), "radio #{span}")
				else     # spacing
					span_item(item.text.empty? ? "&nbsp;&nbsp;&nbsp&nbsp;&nbsp;" : div_item(item.text, "radiolabel"), "radio #{span}")
				end
			end
		end
		# default value, obsoleted. Default value is set when no value is given in create_cells
		if show_all
			newform << div_item("<input id='#{c_id}_9' name='#{question_no}[#{c_id}]' type='radio' value='9' #{checked ? '' : checked} style='display:none;' >",  # removed />
			"hidden_radio")
		end
		newform.join
	end  

	# TODO: like to_html but for fast
	def fast_input_form(options = {}, value = nil)  # 20-9 is value deprecated?
		disabled = options[:disabled] ? true : false
		show_all = options[:show_all].nil? || options[:show_all] #show_all = options[:show_all].nil? ? false : true
		fast     = options[:fast] ? true : false
		edit     = options[:edit] ? true : false
		value    = options[:value] || nil
		no       = options[:number].to_s || self.question.number.to_s 
		c_id     = cell_id(no)

		newform = []
		question_no = "Q" + no # self.question_no.number.to_s
		required = self.required? ? "required" : ""

		label = []
		# show_label = true
		switch_src = ""
		show_value = false
		self.question_items.each_with_index do |item, i|
			switch_src = (i > 0 && !fast) ? switch_source(options) : "" # set switch on positive answers; 0 is 'no'
			values << item.value
			show_value = true if(item.text.to_i == 0 and not ((item.text == "0") || (item.text == "1")))
			label << (show_value || (item.text.to_i == 0 and not ((item.text == "0") || (item.text == "1"))) ? ("<span>#{item.value} = #{item.text}</span>") : item.text) unless item.text.empty?
		end
		# if items.to_i has duplicates, they are probably 0's, meaning that they have text in them, not just numbers as values. When more than one text becomes 0, there's more than one not-integer text
		# shows text values, except where all item texts are numbers
		show_label = self.question_items.map { |item| item.text.to_i }.select {|i| i == 0}.size > 1
		newform = div_item((show_label ? label.join(", ") : ""), "radiolabel") <<
		span_item("<input id='#{c_id}' " <<
		"name='#{question_no}[#{c_id}]' class='rating #{required} #{switch_src} #{c_id}' type='text' #{(self.value.nil? ? "" : "value='" + self.value.to_s + "'")} size='2' >", "radio")  << # removed />
		"\n" << self.add_validation(options)
		return newform
	end

	def values
		vals = self.question_items.collect { |item| item.value.to_s unless item.value.empty? }.compact.sort
		vals << "9"
	end

	def validation_type
		"oneOf"
	end  
end

class Description < QuestionCell

	def to_html(options = {})
		onclick    = options[:onclick]
		switch_off = options[:switch_off]
		class_switch = switch_target(options) unless switch_off
    class_names  = class_name + ((class_switch.blank? or switch_off) ? " #{outer_span}" : " #{class_switch} #{outer_span}" )

		options[:outer_span] = outer_span(options[:last])
		colspan = class_name.include?("description4lab4") && "colspan='3'" || ""
		id_class = id_and_class(options)
    
    klass_name = class_name
    fast = options[:fast] ? true : false
    klass_name << (fast && "" || " " + switch_target(options))

    "<div #{onclick} #{colspan} id='td_#{cell_id(options[:number])}' class='#{klass_name}'>#{form_template(options)}</div>"
	end

  def outer_span(last = false)
    span = case class_name
    when "description3lab" : "span-4"
    when "description2lab1": "span-6"
    when "description3lab2": "span-9"
    when "description3lab3": "span-9"
    when "description3lab4": "span-12"
    when "description5lab4": "span-17"
    when "description4": "span-12"
    when "description3": "span-10"
    when "description7": "span-17"
      # when "rating7": "span-16"
    else ""
    end
    span << " last" if last
    span
  end
  
	def form_template(options = {}) # value = nil, show_all = true, disabled = false)
    # fast = options[:fast] ? true : false
		show_values = options[:show_values]

    # klass_name = fast ? "" : switch_target(options)
	  newform = []

		question_items.each_with_index do |item, i|
		  span = inner_span(question_items.size, question_items.size-1 == i)
		  puts "description inner span: #{span}"
			text = if show_values
				span_item(item.value.nil? ? item.value : "#{item.value} = #{item.text}", span)
			else
				div_item(item.text, span)
			end
			newform << text
		end
		newform.join
	end

  def outer_span(last = false)
    # puts "Class_name: #{class_name}"
    span = case class_name
    when /description3lab4/: "span-9"
    when /description4lab4/: "span-12"
    when /description5lab4/: "span-16"
    when /description7lab4/: "span-16"
    else "span-9"
    end
    span << " last" if last
    span
  end
  
  def inner_span(no_items = 3, last = false)
      span = no_items < 6 && "span-3" || "span-2_5"
		  span = "#{span} last" if last
      # puts "desc span: #{span}"
      span
  end
  
	def fast_input_form(options = {})
		form_template(options.merge({:show_values => true}))
	end
end


class TextBox < QuestionCell

	#  def create_form(value = nil)
	#    form_template(value, false, true)
	#  end
  def outer_span(last = false)
    span = "span-7"
    span << " last" if last
    span
  end
  
  def inner_span
    "span-7"
  end

	def form_template(options = {}) # value = nil, show_all = true, disabled = false)
		disabled = options[:disabled] ? true : false
		answer   = options[:answers]
		show_all = options[:show_all].nil? || options[:show_all] #show_all = options[:show_all].nil? ? false : true
		fast     = options[:fast] ? true : false
		edit     = options[:edit] ? true : false
		no       = options[:number].to_s || self.question.number.to_s 
		c_id     = cell_id(no)

		question_no = "Q" + no # self.question.number.to_s
    span = "span-7"
    
		newform = []
		self.question_items.each do |item|
			if disabled
				newform << div_item(self.value, "itemtextbox #{span}")
			elsif answer
				newform << (self.value.blank? ? "" : "<div id='#{c_id}' class='answer_textbox #{span}'>#{self.value}</div>")
			else
				newform << div_item("<textarea id='#{c_id}' class='comment' name='#{question_no}[#{c_id}]' cols='38' rows='5'>#{self.value}</textarea>", "itemtextbox #{span}")
			end
		end
		newform.join
	end

	def fast_input_form(options = {})
		form_template(options.merge({:show_values => true}))
	end
end

module SurveyBuildersHelper  # TODO: renamed from SurveyBuildersHelper - check that it works!

  TEXTBOX_ROWS = 4
  TEXTBOX_COLS = 22

  def color_picker(name)
    #build the hexes
    hexes = []
    (1..15).step(3) do |one|
      (1..15).step(3) do |two|
        (1..15).step(3) do |three|
          hexes << "" + one.to_s(16) + two.to_s(16) + three.to_s(16)
        end
      end
    end

    arr = []
    on_change_function = "onChange=\"$('color_div').style.backgroundColor = '#' + this[this.selectedIndex].value; $('survey_color').value = '#' + this[this.selectedIndex].value;\""
    15.times { arr << "&nbsp;" }
    returning html = '' do
      html << "<div id=\"color_div\" style=\"border:1px solid black;z-index:100;position:absolute;width:30px\"> &nbsp; </div> "
      html << "<select name=#{name}[color] id=#{name}_color #{on_change_function}>"
      html << hexes.collect {|c|
        "<option value='#{c}' style='background-color: #{c}'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</option>" }.join("\n")
        html << "</select>"
      end
    end
       
  #### these methods are used to create the add_question view ####

  def div_item(html, type)
    "<div class='#{type}'>#{html}</div>"
  end
  
  # create add_question rows & columns. Used by view
  def create_add_question(rows = 4, cols = 4)
    contents = []
    1.upto(rows) do |i|
      row_no += 1
      contents << "\t<tr id='row#{i}' class='row'>"
      1.upto(cols) do |j|
        col_no += 1
        contents << "\n\t\t<td id='cell#{i}_#{j}' class='cell'>\n\t\t\t" << q_item(i, j) 
        contents << "\n\t\t</td>"
      end
      contents << "\n\t</tr>\n"
    end
    return contents.join
  end


  def create_cell_id(row, col)
    return "cell" + row.to_s + "_" + col.to_s
  end
  
  # create select options with question types or options for a specific question type
  def q_item(row, col, options = Survey.OPTIONS)
    form = select("row"<<row.to_s, "col"<<col.to_s, 
    options, { :include_blank => true },
      { :onchange => remote_function(
        :with => "'choice=' + this.value",
        :url => { :action => :change_form, :id => create_cell_id(row, col) })})
    return form
  end
  
  # when called, calculate number of existing answer_items and return the next number
  def answer_item(row, options = ANSWER_ITEMS)
    form = select("row"<<row.to_s, "col"<<0.to_s, 
    options, { :include_blank => true },
      { :onchange => remote_function(
        :with => "'choice=' + this.value",
        :url => { :action => :next_answer_item, :id => create_cell_id(row, 0) })})
    return form  
  end
  
  # params needed: type of form, id col row
  def to_question_item_form
    id = params[:id]
    remote_function( :with => "'choice=' + this.value", :url => { :action => :change_form, :id => id } )
  end

  # with input text fields (labels) instead of choices
  # changed to use text_fields for descriptions
  def create_radiobuttons(cell, n, index, values = [], questiontype = "radio")
    result = ""
    pretty_strings(values)
    
    no = (values.size > n) ? values.size : n

    no.times do |i|
      btnno = ((index == 0) ? i : i+1).to_s
      val = values[i] || ""
      inputtype = questiontype || "radio"     # always "radio" ?!
      begintext = val =~ /text/               # make space for text description, eg. Ja - beskriv
      if begintext == 0  # text answer to rating choice (no text before 'text')
        val.sub!("text", "   ")
        formname = "rating#{index}_" << n.to_s << "text"
      else
        val.sub!("text", " - beskrivelse")
        formname = "rating#{index}_" << n.to_s << "label"
        result << radio_button(cell, inputtype, btnno)
      end
      result << "&nbsp;"
      fieldsize = val.length
      # empty val is for no descriptions
      result << text_field(cell, formname << "_" << btnno, { :value => val, :size => fieldsize } ) unless val.empty? 
    end
    if values.empty?                                     # default value for radiobutton
      result << hidden_field(cell, ("rating#{index}_" << n.to_s), { :value => n })
    end
    return result
  end
  
  # optional descriptions are pre-set values
  # option arg is type of textfield eg. listitem or textfield
  def create_textfields(n, cell, values = [], questiontype = "textfield")
    result = ""
    pretty_strings(values)  
    q_type = questiontype + n.to_s      
    n.times do |i|
      val = values[i] || ""
      # result << (i+1).to_s << ". "
      result << text_field(cell, (q_type + "_" << (i+1).to_s), { :value => val, :size => val.length }) << "&nbsp;"
    end
    return result
  end

  # as create_textfields, but with boxes (text_areas) instead of fields
    def create_textareas(n, cell, values = [], questiontype = "textarea")
    result = ""
    pretty_strings(values)  
#    q_type = questiontype # + n.to_s      
    n.times do |i|
      val = values[i] || ""
      result << (text_area(cell, questiontype, { :value => val, :cols => TEXTBOX_COLS, :rows => TEXTBOX_ROWS})) << "&nbsp;"
    end
    return result
  end
  
  # as create_textfields, but making options for a select list (text, value)
    def create_selectoptions(n, cell, values = [], questiontype = "selectoption")
    result = ""
    pretty_strings(values)
    q_types = questiontype.split("_")
    results << text_field(cell, q_types.shift, { :value => "", :size => 20 }) if q_types.include? "ListItem"
    q_type = q_types.last + n.to_s      
    n.times do |i|
      val = values[i] || ""
      #puts "Option " << i.to_s
      # result << "<div class='selectoption'>"
      result << (text_field(cell, (q_type + "_" << (i+1).to_s), { :value => "", :size => 12})) << "&nbsp;"
      result << (text_field(cell, (q_type + "Val" << n.to_s << "_" << (i+1).to_s), { :value => (i+1).to_s, :size => 1})) << "&nbsp;\n"
      # result << "</div>"
    end
    #puts "Create_textareas: " << result
    return result
  end
    
  # should support for multiple checkboxes with labels, not tested
  def create_checkbox(n, cell, values = [], questiontype = "checkbox") # cell was formhash
    result = ""
    pretty_strings(values)
    q_type = questiontype + n.to_s
    n.times do |i|
      length = [values[i].length, 4].max
      result << check_box(cell, questiontype + n.to_s << "_" << (i+1).to_s) << "&nbsp;"
      result << text_field(cell, questiontype+"label" + n.to_s << "_" << (i+1).to_s, { :value => values[i], :size => length })
    end
    return result
  end
  
  # used for values in forms. replaces _ with space
  def pretty_strings(stringarr)
    if stringarr.instance_of? Array
      return stringarr.collect! { |str| str.gsub("_", " ") }
    else
      return stringarr.gsub!("_", " ")
    end
  end
  
  # return form field dependent on question item type
  # args is a hash of row, col, cell(name)   2nd pass
  def question_item_form(question_item, args)
    # check for ratings 2nd pass
    cell = args[:cell]
    options = question_item.split("|")
    optno = question_item.count("|")  # obsolete and use options.size instead?
    #puts "question_item_form item:" << question_item
    optno -= 1 if question_item.split("|").last == "text"  # make yes/no/text a rating2

      type2ndpass = options.shift # type of method to be called is determined by first arg
      #puts "Question_item_form, options: " << optno.to_s << " type: " << type2ndpass
      type2ndpass.scan(/[a-z]*(\d)/)
      index = $1.to_i
      
      case type2ndpass
      when /choices\d?/:          # rating
        return create_radiobuttons(cell, optno, index, options, "rating" << optno.to_s) + rating_props(cell)
      when "descriptions":     # descriptions with textfields
        return create_textfields(options.length, cell, options, "Description") + textfield_props
      when "text_options":
        return text_field(cell, "SelectOption#{options.length}Text", { :size => 15 } ) + create_selectoptions(options.length, cell, options, "SelectOption")
      when "options":          # select options
        return create_selectoptions(options.length, cell, options, "SelectOption")
      end

      #puts "Question_item: " << question_item
      # other types than ratings
      form = case question_item
      when "Text": text_area(cell, "QuestionText", {:cols => 18, :rows => 4})
      when "Information": text_area(cell, "Information", {:cols => 50, :rows =>4})
      when "ListItem": create_textfields(1, cell, "", "ListItem")
      when "ListItemComment": create_textfields(1, cell, "", "ListItem") + create_textareas(1, cell, "", "ListItemBox")
      when "ListItemx2": create_textfields(2, cell, "", "ListItem")
      when "TextBox": create_textareas(1, cell, "", "TextBox") #text_area(cell, "QuestionText", {:cols => 18, :rows => 4}) #
        #    when "SelectList": create_selectoptions(2, cell, "", "selectoption") # "SelectList not yet implemented"
      when "CheckboxAccess": create_checkbox(1, cell, ["Ingen"], "Checkbox")
      when "Checkbox": create_checkbox(1, cell, ["Tekst"], "Checkbox")
      when "Placeholder": hidden_field(cell, "placeholder") # create_textfields(1, cell, "", "placeholder")  # create empty space
      when "":  # flash, change_back_form# do nothing. fix. Same as pressing change
      else flash[:notice] = "Operation not supported" 
        q_item(args[:row], args[:col]) #"Undefined question item type"
      end
      return form
    end

  # rating_form refactored
  def rating_choices(type)
    # choices with index 0
    ratings_0 = {
      "Rating 2" => "Rating0_2",
      "Rating 3" => "Rating0_3",
      "Rating 4" => "Rating0_4",
      "Rating 5" => "Rating0_5",
      "Rating 6" => "Rating0_6",
      "Rating 7" => "Rating0_7"
    }
    ratings_1 = {
      "Rating 2" => "Rating1_2",
      "Rating 3" => "Rating1_3",
      "Rating 4" => "Rating1_4",
      "Rating 5" => "Rating1_5",
      "Rating 6" => "Rating1_6",
      "Rating 7" => "Rating1_7"      
    }
    choices0_2 = { 
      type => "choices0|index0|2",
      "(tom)" => "choices0||", 
      "Indtast valg" => "choices0| | ", 
      "0 1" => "choices0|0|1",
      "Nej Ja" => "choices0|Nej|Ja", 
      "Nej Ja - beskriv" => "choices0|Nej|Ja" }
    choices0_3 = { 
       "(tom)" => "choices0|||", 
       "Indtast valg" => "choices0| | | " , 
       "0 1 2" => "choices0|0|1|2", 
       "Dårligt, middel, bedre" => "choices0|Dårligt|Middel|Bedre" }
    choices0_4 = { "(tom)" => "choices0||||", 
       "Indtast valg" => "choices0| | | | " , 
       "0 1 2 3" => "choices0|0|1|2|3", 
       "Ingen, 1, 2 eller 3, 4 eller flere" => "choices0|Ingen|1|2_eller_3|4_eller_flere" }
    choices0_5 = { "(tom)" => "choices0|||||", 
       "Indtast valg" => "choices0| | | | | " , 
       "0 1 2 3 4 5" => "choices0|0|1|2|3|4" }
    choices0_6 = { 
       "(tom)" => "choices0||||||", 
       "Indtast valg" => "choices0| | | | | | " , 
       "0 1 2 3 4 5" => "choices0|0|1|2|3|4|5" }
    choices0_7 = { 
       "(tom)" => "choices0|||||||", 
       "Indtast valg" => "choices0| | | | | | |" , 
       "0 1 2 3 4 5 6" => "choices0|0|1|2|3|4|5|6" }
       
    # choices with index 1
    choices1_2 = { 
      type => "choices0|index1|2",
      "(tom)" => "choices1||", 
      "Indtast valg" => "choices1| | ", 
      "Nej Ja" => "choices1|Nej|Ja", 
      "Nej Ja - beskriv" => "choices1|Nej|Ja",
      "Ja Nej" => "choices1|Ja|Nej" }
    choices1_3 = { 
       "(tom)" => "choices1|||", 
       "Indtast valg" => "choices1| | | " , 
       "1 2 3" => "choices1|1|2|3", 
       "Mindre, som, mere end gns" => "choices1|Mindre_end_gennemsnit|Som_gennemsnit|Mere_end_gennemsnit",
       "Dårligere, som, bedre end gns" => "choices1|Dårligere_end_gennemsnit|Som_gennemsnit|Bedre_end_gennemsnit", 
       "Dårligt, middel, bedre" => "choices1|Dårligt|Middel|Bedre",
       "Færre end 1, 1 eller 2, 3 eller flere" => "choices1|Færre_end_1|1_eller_2|3_eller_flere", 
       "Meget Godt, Nogenlunde, Ikke Særlig Godt" => "choices1|Meget_godt|Nogenlunde|Ikke_særlig_godt" }
    choices1_4 = { "(tom)" => "choices1||||", 
       "Indtast valg" => "choices1| | | | " , 
       "1 2 3 4" => "choices1|1|1|2|3", 
       "Ingen, 1, 2 eller 3, 4 eller flere" => "choices1|Ingen|1|2_eller_3|4_eller_flere",
       "Langt under middel, Under middel, Middel, Over middel" => "choices1|Langt_under_Middel|Under_middel|Middel|Over_middel" }
    choices1_5 = { "(tom)" => "choices1|||||", 
       "Indtast valg" => "choices1| | | | | " , 
       "1 2 3 4 5" => "choices1|1|2|3|4|5",
       "Langt Under, Under, Middel, Over, Langt Over" => "choices1|Langt_Under_Middel|Under_Middel|Middel|Over_Middel|Langt_Over_Middel" }
    choices1_6 = { 
       "(tom)" => "choices1||||||", 
       "Indtast valg" => "choices1| | | | | | " , 
       "1 2 3 4 5 6" => "choices1|1|2|3|4|5|6" }
    choices1_7 = { 
       "(tom)" => "choices1|||||||", 
       "Indtast valg" => "choices1| | | | | | |" , 
       "1 2 3 4 5 6 7" => "choices1|1|2|3|4|5|6|7", 
       "Under til over gns" => "choices1|Langt_under_gennemsnittet|Under_gennemsnittet|Lidt_under_gennemsnittet|Som_gennemsnittet|Lidt_over_gennemsnittet|Over_gennemsnittet|Langt_over_gennemsnittet" }

    options = case type
    when "Rating_0" : ratings_0.to_a
    when "Rating_1" : ratings_1.to_a
    when /Rating(\d)_(\d)/ : eval("choices#{$1}_#{$2}").to_a
    else [ "Not supported", "choices|not|supported" ]
    end
    return options
  end
  
  # 2nd pass form. Used by ratings. A rating with a number is chosen, and the form options are
  # changed to the available options for that rating type. Eg. 'numbers (0, 1, 2)', "god, middel, daarlig"
  # args are the same as for question_item_form, ie. row col cell
  def rating_form(type, row, col)
    options = rating_choices(type)
    #puts "rating_form: " << "\n" << q_item(row, col, options)
    row = row.scan(/[0-9]+/).join  # join, since scan returns array
    col = col.scan(/[0-9]+/).join
    return q_item(row, col, options)
  end

  # generates properties for rating type question cells
  def rating_props(cell_id)
    html = "Properties coming here"
    html = check_box(cell_id + "_props", "required") << "<label for='#{cell_id}_props_required'>Skal besvares</label>"
    props = "<div id='#{cell_id}_props' class='properties'>" + html + "</div>"
  end
  
  # properties for text fields
  def textfield_props
    ""
  end
  
  def textbox_props
    ""
  end
  
  # 2nd pass form as rating_form.
  # create a select form with descriptions
  def description_form(type, row, col)
    # choices whose values start with index 0
    # description0_2 = [ ["Indtast", "descriptions| | "], ["Nej Ja", "descriptions|Nej|Ja"], ["Falsk Sand", "descriptions|Falsk|Sand"], ["Forkert Rigtigt", "descriptions|Forkert|Rigtigt"] ]
    # description0_3 = [ ["Indtast", "descriptions| | | "], ["Rigtigt, Ved ikke, Forkert", "descriptions|Rigtigt|Ved_ikke|Forkert"], 

    description2 = [ ["Indtast", "descriptions| | "], ["Ja Nej", "descriptions|Ja|Nej"], ["Sand Falsk", "descriptions|Sand|Falsk"], ["Rigtigt Forkert", "descriptions|Rigtigt|Forkert"] ]
    description3 = [ ["Indtast", "descriptions| | | "], ["Rigtigt, Ved ikke, Forkert", "descriptions|Rigtigt|Ved_ikke|Forkert"], 
     ["Mindre, som, mere end gns", "descriptions|Mindre_end_gennemsnit|Som_gennemsnit|Mere_end_gennemsnit"],
     ["Dårligere, som, bedre end gns", "descriptions|Dårligere_end_gennemsnit|Som_gennemsnit|Bedre_end_gennemsnit"],
     ["Dårligt, middel, bedre", "descriptions|Dårligt|Middel|Bedre"], ["Færre end 1, 1 eller 2, 3 eller flere", "descriptions|Færre_end_1|1_eller_2|3_eller_flere"],
     ["Meget Godt, Nogenlunde, Ikke Særlig Godt", "descriptions|Meget_godt|Nogenlunde|Ikke_særlig_godt"] ]
    description4 = [ ["Indtast valg", "descriptions| | | | " ], ["0 1 2 3", "descriptions|0|1|2|3"], ["Ingen, 1, 2 eller 3, 4 eller flere", "descriptions|Ingen|1|2_eller_3|4_eller_flere"], 
        ["Langt Under Middel, Under Middel, Middel, Over Middel", "descriptions|Langt_Under_Middel|Under_Middel|Middel|Over_Middel"] ]
    description5 = [ ["Indtast valg", "descriptions | | | | " ], 
     ["0 1 2 3 4 5", "descriptions|0|1|2|3|4|5"], ["Langt Under, Under, Middel, Over, Langt Over", "descriptions|Langt_Under_Middel|Under_Middel|Middel|Over_Middel|Langt_Over_Middel"] ]
    description6 = [ ["Indtast valg", "descriptions | | | | | " ], 
     ["0 1 2 3 4 5", "descriptions|0|1|2|3|4|5"] ]
    description7 = [ ["Indtast valg", "descriptions | | | | | |" ], 
     ["0 1 2 3 4 5 6", "descriptions|0|1|2|3|4|5|6"], ["Under til over gns", "descriptions|Langt_Under_gns|Under_gns|Lidt_Under_gns|Som_gns|Lidt_over_gns|Over_gns|Langt_over_gns"] ]
    options = case type
    # when "Description0_2": description0_2 
    # when "Description0_3": description0_3 
    # when "Description0_4": description0_4 
    # when "Description0_5": description0_5 
    # when "Description0_6": description0_6 
    # when "Description0_7": description0_7
    # when "Description1_2": description1_2 
    # when "Description1_3": description1_3 
    # when "Description1_4": description1_4 
    # when "Description1_5": description1_5 
    # when "Description1_6": description1_6 
    # when "Description1_7": description1_7
      when "Description_2": description2 
      when "Description_3": description3 
      when "Description_4": description4 
      when "Description_5": description5 
      when "Description_6": description6 
      when "Description_7": description7
      else [ "Description not available", "descriptions|Description|not|available"]
    end
    row = row.scan(/[0-9]+/).join  # join, since scan returns array
    col = col.scan(/[0-9]+/).join
    return q_item(row, col, options)  # create_descriptions(options, htmloptions)
  end

  # works like rating choices. Creates choices for select options
  def select_options(type)
    options = []
    q_types = type.split("_")
    if_text = q_types.include? "ListItem"
    16.times do |i|
      if i<2
        next
      end
      options << ["Mulighed " << (i-1).to_s, (if_text ? "text_options" : "options") << "| "*i]
    end
    return options
  end
  
  # 2nd pass form. Used by select options. 
  # args are the same as for question_item_form, ie. row col cell
  def selectopt_form(type, row, col)
    options = select_options(type)
    row = row.scan(/[0-9]+/).join  # join, since scan returns array
    col = col.scan(/[0-9]+/).join
    #puts "selectoptions_form: " << type << "\n q_item(result) " << q_item(row, col, options)
    return q_item(row, col, options)
  end


end

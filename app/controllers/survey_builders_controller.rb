# extracted from SurveyController because it handles
# everything with creating surveys
class SurveyBuildersController < ApplicationController
  #helper SurveyBuilderHelper
  require_dependency "survey"
  layout "survey"
  
  def index
    redirect_to surveys_path
  end

  # GETs should be safe (see http://www.w3.org/2001/tag/doc/whenToUseGet.html)
  # verify :method => "post", :only => [ :destroy, :create, :update, :answer ]
  
  def show
    redirect_to survey_path(Survey.find(params[:id]))
  end

  def show_fast
    redirect_to survey_show_fast_path(Survey.find(params[:id])) 
  end

  def new
    @survey = Survey.new
  end

  def create
    @survey = Survey.new(params[:survey])
    if @survey.save
      flash[:notice] = 'Spørgeskemaet er oprettet.'
      redirect_to :controller => surveys_path
    else
      render new_survey_builder_path
    end
  end

  def edit
    @survey = Survey.find(params[:id])
  end

  # finds the right item and sets it
  # inline edit
  # only used for question cells with one item!?
  def set_question_cell_items
    # get value from form which is text
    # generate items string to set in db
    # needs right cell. Id?
    params.inspect
  end
  
  def update
    @survey = Survey.find(params[:id])
    # make sure numbers are in right format
    numbers = params[:survey][:age].split("-")
    params[:survey][:age] = numbers.map do |num|
      if num =~ /(\d+).(\d+)/
        $1 + "." + $2
      else
        num
      end
    end.join("-")

    if @survey.update_attributes(params[:survey])
      flash[:notice] = 'Spørgeskemaet er opdateret.'
      redirect_to surveys_path
    else
      render edit_survey_builder_path(@survey)
    end
  end

  def destroy
    Survey.find(params[:id]).destroy
    flash[:notice] = "Spørgeskema er slettet"
    redirect_to surveys_path
  end


  def add_question
    @survey = Survey.find(params[:id])
  end
  
  def delete_question
    @question = Question.find(params[:id]).destroy
    render :update do |page|
      elem = "question" << params[:number]
      page.visual_effect :SwitchOff, "question_number"<<params[:number], :duration => 1.5
    end
  end

  # creates a list of items to be created. From params this list is lacking since it doesn't have all forms
  # # Parameters: {"commit"=>"Add Question", "id"=>"9", "cell1_1"=>{"rating3label_1"=>"Mindre end gennemsnit", 
  #   "rating3label_2"=>"Som gennemsnit", "rating3label_3"=>"Mere end gennemsnit"},
  #  "cell1_2"=>{"Checkboxlabel1_1"=>"Ingen", "Checkbox1_1"=>"0"}, 
  #  "cell2_1"=>{"Checkboxlabel1_1"=>"label", "Checkbox1_1"=>"0"}, "row2"=>{"col2"=>"", "col3"=>""}, 
  #  "cell1_3"=>{"rating3"=>"empty"}, "row3"=>{"col1"=>"", "col2"=>"", "col3"=>""}, "row4"=>{"col1"=>"", "col2"=>"", "col3"=>""}}
  # 
  #  answer item is not set right
  def sanitize_params(values)  # params hash
    cells = Hash.new
    answeritem = {}   # hash {"1" => "answeritem2", "2" => "answeritem2"}  row-indexed by string(!)
    answer_item_set = { }  # hash { row => true/false } set answer item only for first cell with type listitem
    row = 0
    # render_text params.inspect
    values.each do |cell, val|  # cell is cell_id, val is a hash of type+value ("ListItem => hello")
      # fill answeritems
      if cell.match(/row(\d+)/)  # fixed. Matches rows of multiple ciphers
        row = $1
        answeritem[row] = params[cell]["answeritem"]    # here cell is row id
        answer_item_set[row] = false  # this row's answer item has not been set
        # next
      end
    end  # first fill answer items hash, then go thru rest
    # "cell1_1"=>{"rating0_3label_0"=>"0", "rating0_3label_1"=>"1", "rating0_3label_2"=>"2"}, 
    # "cell1_2"=>{"rating2"=>"0", "rating0_2"=>"2"}
    values.each do |cell, val|  # "cell1_1"=>{"rating0_3label_0"=>"0" # cell => { val => i_val}
      RAILS_DEFAULT_LOGGER.debug "sanitize: cell: #{cell.inspect} val: #{val.inspect}"
      if cell.match(/cell(\d+)_\d/)   # match on row number (more ciphers than 1!)
        row = $1   # set row to current
        ncell = Hash.new
        cells[cell] = ncell  #new cell hash
        ncell["items"] = []
        val.each do |type, i_val|      # fx {"ListItem" => "hello" }  # items in each cell
          # items = [["radio", 0, "Nej"], ["radio", 1, "Ja"]]
          # split into type (rating3_label1) and label (Mindre end...)
          case type.downcase  # /rating(\d)_(\d+)
          when /rating(\d)_(\d+)/  # rating0_2 or rating1_3_label1   30-10 refactored: label to be saved as third value
            index = $1.to_i # index 0 or 1 (choices go from 0..n or 1..n)  
            pos = (index == 0) ? 1 : 0 
            n = $2.to_i     # number of choices
            ncell["no"] = n
            ncell["type"] = "Rating"
            ncell["answeritem"] = answeritem[row] #unless answer_item_set[row]
            if type.downcase =~ /rating(\d)_([0-9]+)label_([0-9]+)/      # save radio item and label item for each
              n     = $2.to_i 
              i     = $3.to_i         # label no. (rating1_3label_1, matcher sidste '1')
              value = index + i
              ncell["items"][pos+i] = ["radio", i_val, i.to_s]     # =>  18-9 FIX many ratings are scored 0..n
            elsif type.downcase =~ /rating(\d)_([0-9]+)/  # no label, set that in qcell.text
              n = $2.to_i                                 #   [ type, label, label ]
              n.times do |i|
                value = index + i  #? i : i+1   # if 2 ratings, values are 0/1, when more values are 1/2/3..
                ncell["items"][pos+i] = ["radio", "", value.to_s]  # 17-9 last was: ""
              end
            end
          when /selectoption[a-z]*(\d+)/
            ncell["type"] = "SelectOption"
            ncell["answeritem"] = answeritem[row] #unless answer_item_set[row]
            if type.downcase =~ /selectoption(\d+)_(\d+)/   # match selectoption5_2
              ncell["no"] = $1.to_i
              val = $2.to_i
              if ncell["items"][val].nil?
                ncell["items"][val] = ["option", i_val]
              else      # set values in right position
                ncell["items"][val] << "option" << i_val
                # ncell["items"][val][1] = i_val
              end
            elsif type.downcase =~ /selectoption(\d+)text/
              ncell["no"] = $1.to_i + 1  # text + options
              ncell["items"][0] = ["listitem", i_val]
            elsif type.downcase =~ /selectoptionval(\d+)_(\d+)/
              val = $2.to_i
              if ncell["items"][val].nil?
                ncell["items"][val] = [nil,nil, i_val]   # append label value as third elem of array
              else
                ncell["items"][val][2] = i_val
              end
            end
          when /checkbox/  # TODO: check if works!  8-2-07
            ncell["type"] = "Checkbox"
            ncell["answeritem"] = answeritem[row]          #unless answer_item_set[row]
            ncell["items"][1] = [] if ncell["items"][1].nil?
            if type.downcase =~ /checkboxlabel/
              ncell["items"][1][1] = i_val
            else      #  /checkbox/  # create one item, a checkbox with a label
              ncell["items"][1][0] = "checkbox"
              ncell["items"][1][2] = i_val
            end
          when /listitem/  # a listitem + commentary box
            ncell["answeritem"] = answeritem[row] #unless answer_item_set[row]
            if type.downcase =~ /listitembox/
                ncell["no"] = 2
                ncell["type"] = "ListItemComment"
                ncell["items"][2] = ["textbox", i_val]  # label should be empty, [1] was "listitembox"
            elsif type.downcase =~ /listitem([0-9]+)_([0-9]+)/   # multiple list items
                ncell["no"] = $1.to_i
                ncell["type"] = "ListItem"
                ncell["items"][$2.to_i] = ["listitem", i_val]
            else
                ncell["items"][1] = ["listitem", i_val]
                ncell["type"] = "ListItem"
                ncell["items"][1] = ["listitem", i_val]
            end
          when /textbox/    # med vaerdi eller uden
            ncell["answeritem"] = answeritem[row]
            ncell["no"] = 1
            ncell["type"] = "TextBox"
            ncell["items"][1] = ["textbox", i_val]
          when /description/
            ncell["answeritem"] = answeritem[row]
            val = type.scan(/Description([0-9])+_([0-9])+/)
            ncell["type"] = "Description"
            ncell["items"][$2.to_i] = ["desc", i_val]
          when /questiontext/
            ncell["type"] = "Questiontext"
            ncell["items"][1] = ["questiontext", i_val]
            ncell["answeritem"] = answeritem[row]
          when /information/
            ncell["type"] = "Information"
            ncell["items"][1] = ["information", i_val]
          when /placeholder/
            ncell["type"] = "Placeholder"
            ncell["items"][1] = ["placeholder", i_val]
            ncell["answeritem"] = answeritem[row]
          end
        end
        # listitemcount = 0
        ncell["items"].shift if ncell["items"][0].nil?  # 1-indexed, except for select option with text label
        #puts "Filtered cells\n" << cells.to_a.join(" => ").to_s
       end
     end
     #puts "answeritems: " << answeritem.inspect << "  set: " << answer_item_set.inspect
     #puts "admin::sanitize_params: " << cells.inspect
     return cells
   end

 
  # params are full of celln_m
  def save_question
    @survey = Survey.find(params[:id])
    @question = Question.new({:survey => @survey})
    # q_number = 
    @question.number = params[:question][:number]
    cells = sanitize_params(params)
    # {"cell1_2"=>{"type"=>"Rating", "items"=>[["radio", 0], ["radio", 1]], "type"=>"checkboxlabel"}}
    # key is cell_id, val is a hash of type+label {"type"=>"ListItem", "items"=>[["radiobutton, 0]])

    cells.each do |cell, attributes|
      cellno = cell.to_s.scan(/[0-9]+/)
      @q_cell = QuestionCell.new( :row => cellno.first.to_i, :col => cellno.last.to_i)
      attributes.each do |cellattr, val|  # val == items|no|type|answeritem
        case cellattr
        when "type":  @q_cell.type = val
        when "items": @q_cell.add_question_items(val)   # appends q_item to db field
        when "answeritem": @q_cell.answer_item = val    # sets answer item for all items (will only be shown for first listitem)
        end    
      end
      @question.question_cells << @q_cell
      @q_cell.question = @question
      @q_cell.preferences = ""  # preferences should be set somewhere. Should be included in sanitized_params
      @q_cell.save
    end
    # @survey.questions << @question
    # @question.survey = @survey
    @question.save
    @survey.save

    flash[:notice] = "Spørgsmålet blev tilføjet."
    redirect_to add_question_survey_builder_path(@survey)
  end

  def change_form
    args = args_id(params[:id])
    html_options = { :class => "action" }
    questionitem = params[:choice]
    updated_form = ""
    change_options = ""   # holds html for addlabels/change/etc
    fast_ratings = false# true  # configuration option

    render :update do |page|
      # 2-pass rating forms are done here
      if questionitem =~ /Rating(\d)_(\d)/  # 3rd pass for ratings, choose final
        index = $1.to_i
        n = questionitem.scan(/[0-9]+/).last # rating_n  # index of rating values
        if fast_ratings
          change_options <<
            link_to_function("add labels",
              remote_function( :url =>
              { :action => :change_form_add_labels, :rating => n, :id => args[:cell] }), html_options)
          updated_form << "<dt class='form'>" << create_radiobuttons(args[:cell], n.to_i, index, options = [], "rating" << n) << "</dt>"
        else  # change to ratings selector
          updated_form = rating_form(questionitem, args[:row], args[:col])
        end
      elsif questionitem =~ /Rating_(\d)/   # 2nd pass for ratings, choose index
        updated_form = rating_form(questionitem, args[:row], args[:col])
      elsif questionitem == "ListItem_SelectList"
        updated_form = "Tekst" + selectopt_form(questionitem, args[:row], args[:col]) # + select_props
      elsif questionitem == "SelectList"
        updated_form = selectopt_form(questionitem, args[:row], args[:col]) # + select_props
      elsif questionitem =~ /Description/
        updated_form = description_form(questionitem, args[:row], args[:col])
      else # 1st pass or 2nd pass rating doing add labels
        
        # add properties link
        property_options = "<span class='options'>" +
        "<a class='action' href='javascript:toggleElem(&quot;#{args[:cell] + '_props'}&quot;)'>" +
                "Egenskaber" + # "<img src='/images/icon_comment.gif' border=0 title='Kommentar' class='comment' />" <<
        "</a>" + "</span>"
            
        updated_form = question_item_form(questionitem, args) + property_options
      end
      # add 'change' option. Always show 'change' to go back to start
      change_options << link_to_function("skift", remote_function(:url => change_back_form_path(args[:cell])),
          html_options)

      page[args[:cell]].replace_html( updated_form << "<span class='options'>" << change_options << "</span>" )
      page.visual_effect :highlight, args[:cell], :duration => 2
    end
  end

  def change_form_add_labels
    args = args_id(params[:id])
    type = "Rating_" + params[:rating].to_s
    html_options = { :class => "action" }
    render :update do |page|
            page[args[:cell]].replace_html(
              select(args[:row], args[:col], rating_choices(type),
  			      { :include_blank => true }, 
  			      { :onchange => to_question_item_form } ) )
      page.visual_effect :highlight , args[:cell], :duration => 2
    end
  end

  # changes form back to original choice menu
  def change_back_form
    args = args_id(params[:id])
    render :update do |page|
            page[args[:cell]].replace_html(
            select(args[:row], args[:col], 
            Survey.OPTIONS,
      			    { :include_blank => true }, 
      			    { :onchange => to_question_item_form } ) )
      page.visual_effect :highlight , args[:cell], :duration => 2
    end
  end
  
  # shows property box form. Checkboxes with 'required' etc.
  def show_properties_form
    args = args_id(params[:id])
    html = "Properties coming here"
    props = "<div class='properties'>" + html + "</div>"
    render :update do |page|
            page.insert_html :bottom, args[:cell],
            "Properties coming here"
      page.visual_effect :highlight , args[:cell], :duration => 2
    end
  end
  
  # calculate next answer item and return this
  def next_answer_item
    args = args_id(params[:id])
    html_options = { :class => "action" }
    questionitem = params[:choice]
    updated_form = ""
    #puts "next_answer_item" << params.inspect
    render :update do |page|
      
    end
  end
  
  def add_question_row
    render :update do |page|
      page.call 'add_question_row'
    end
  end
  
  # fix by calling page.call with argument which is output of q_item
  def add_question_column
    render :update do |page|
#      page.select("tr.row").each do |element, index|
      page.call 'add_question_column'
    end
  end
  
  def delete_question_row
    render :update do |page|
      page.select("tr.row").last.remove
    end
  end  
  
  def delete_question_column
    render :update do |page|
      page.call 'delete_question_column'
    end
  end

  
   # split col1_row1 to [col1, row1] and adds cell1_1
  def args_id( cssid )
    pos = cssid.to_s.scan(/[0-9]+/)
    row = 'row' << pos.first
    col = 'col' << pos.last
    form = 'cell' << pos.first << "_" << pos.last
    return Hash[:col => col, :row => row, :cell => form]
  end
  
  def row_col_numbers( cellid )
     pos = cellid.to_s.scan(/[0-9]+/)
     row = pos.first
     col = pos.last
     return Hash[:col => col, :row => row]
   end
   
   
  protected
  before_filter :superadmin_access


  def superadmin_access
    if !current_user.nil? && current_user.has_access?(:superadmin)
      return true
    elsif !current_user.nil?
      redirect_to "/login"
      flash[:notice] = "Du har ikke adgang til denne side"
      return false
    else
      redirect_to "/login"
      flash[:notice] = "Du har ikke adgang til denne side"
      return false
    end
  end



end

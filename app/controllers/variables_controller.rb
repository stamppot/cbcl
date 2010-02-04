class VariablesController < ApplicationController
  
  layout 'cbcl'
  
  # GET /variables
  # GET /variables.xml
  def index
    @variables = Variable.and_survey.and_question.find(:all, :order => 'survey_id, question_id, row, col, item')

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @variables }
    end
  end

  # GET /variables/1
  # GET /variables/1.xml
  def show
    @variable = Variable.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @variable }
    end
  end

  def show_question
    q = Question.find params[:id]
    @variables = Variable.and_survey.and_question.find(:all, :conditions => ['question_id = ?', q.id], :order => 'row, col, item')
    render :index
  end

  def show_survey
    s = Survey.find params[:id]
    @variables = Variable.and_survey.and_question.find(:all, :conditions => ['survey_id = ?', s.id], :order => 'question_id, row, col, item')
    render :index
  end

  # GET /variables/new
  # GET /variables/new.xml
  def new
    @variable = Variable.new
    @survey = Survey.first
    @options = {:show_all => true, :onclick => "onclick='updateRowCol(this.id);'"}
    
    @question = @survey.questions.first
    # @options = {:answers => true}
    
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @variable }
    end
  end

  # GET /variables/1/edit
  def edit
    @variable = Variable.find(params[:id])
  end

  # POST /variables
  # POST /variables.xml
  def create
    @variable = Variable.new(params[:variable])
    @question = @variable.question
    @survey = @variable.survey
    
    # look up item and set item in variable
    
    respond_to do |format|
      if @variable.save
        flash[:notice] = 'Variabel er oprettet.'
        format.js   { 
          render :update do |page|
            page.visual_effect :highlight, 'status'
            page.replace_html 'status', "<span style='padding:3px; background: lightgreen; border: 1px solid green;'>Variabel #{@variable.var} tilføjet.</span>"
            page << "$(currHighlight).style.backgroundColor = 'lightgreen'"
            page << "currHighlight = 'td_q_#{@variable.question.number}_1_1'"
          end
        }
        format.html { redirect_to(@variable) }
        format.xml  { render :xml => @variable, :status => :created, :location => @variable }
      else
        format.js {
          render :update do |page|
            page.replace_html 'status', "<span style='padding:3px; background: red; border: 1px solid darkred;'>Variabel #{@variable.var} blev ikke tilføjet!  #{@variable.errors.inspect}</span>"
            page.visual_effect :highlight, 'status'
          end
        }
        format.html { render :new }
        format.xml  { render :xml => @variable.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /variables/1
  # PUT /variables/1.xml
  def update
    @variable = Variable.find(params[:id])

    respond_to do |format|
      if @variable.update_attributes(params[:variable])
        flash[:notice] = 'Variabel er rettet.'
        format.html { redirect_to(@variable) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @variable.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /variables/1
  # DELETE /variables/1.xml
  def destroy
    @variable = Variable.find(params[:id])
    @variable.destroy

    respond_to do |format|
      format.html { redirect_to(variables_url) }
      format.xml  { head :ok }
    end
  end
  
  def update_questions
    # @questions = Survey.and_q.find(params[:survey_id]).questions
    # @survey = Survey.and_q.find(params[:survey_id])
    @question = Question.find_by_survey_id(params[:survey_id], :conditions => ['number = ?', 1])
    @options = {:show_all => true, :onclick => "onclick='updateRowCol(this.id);'", :switch_off => true}
    
    render :update do |page|
      page.replace_html 'variable_question_id', options_for_select(question_options(params[:survey_id]))
      page.replace_html 'question_view', :partial => 'surveys/question'
      page.replace_html 'variable_row', options_for_select(r = @question.rows, r)
      page.replace_html 'variable_col', options_for_select(c = @question.cols, c)
      page << "$('question_id').value = #{@question.id}"
      page << "survey_prefix = '#{(@question.survey.prefix)}';"
      page << "question_prefix = '#{@question.number.to_roman.downcase}';"
      page << "updatePreview()"
    end
  end

  def update_rows
    @question = Question.and_question_cells.find(params[:question_id])
    @options = {:show_all => true, :onclick => "onclick='updateRowCol(this.id);'", :switch_off => true}

    render :update do |page|
      page.replace_html 'question_view', :partial => 'surveys/question'
      page.replace_html 'variable_row', options_for_select(r = @question.rows, r)
      page.replace_html 'variable_col', options_for_select(c = @question.cols, c)
      page << "$('question_id').value = #{@question.id}"
      page << "survey_prefix = '#{(@question.survey.prefix)}';"
      page << "question_prefix = '#{@question.number.to_roman.downcase}';"
      page << "updatePreview()"
    end
  end

  
  private
  
  # return no. rows for this question
  def row_options(question)
    @rows = question.question_cells.select { |cell| cell.type =~ /Rating|TextBox|Comment/ }.collect do |cell|
      [cell.row, cell.row]
    end
  end

  # return no. rows for this question
  def col_options(question)
    @cols = question.question_cells.select { |cell| cell.type =~ /Rating|TextBox|Comment/ }.collect do |cell|
      [cell.col, cell.col]
    end
  end
  
end

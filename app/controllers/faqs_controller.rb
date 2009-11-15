class FaqsController < ApplicationController

  layout 'survey'
  
  uses_tiny_mce(:options => {:theme => 'advanced',
    :browsers => %w{msie gecko safari},
    :theme_advanced_toolbar_location => "top",
    :theme_advanced_toolbar_align => "left",
    :theme_advanced_resizing => true,
    :theme_advanced_resize_horizontal => false,
    :paste_auto_cleanup_on_paste => true,
    :theme_advanced_buttons1 => %w{bold italic underline separator bullist numlist separator link unlink image undo redo},
    :theme_advanced_buttons2 => [],
    :theme_advanced_buttons3 => [],
    :convert_newlines_to_brs => true,
    :plugins => %w{contextmenu paste}})
    
  # do not use, should be for faq_section only
  def index
    @sections = FaqSection.and_faqs.find(:all, :order => :position)
  end
  
  def show
    @question = Faq.find(params[:id])
    
    render :update do |page|
      page.replace_html 'right', :partial => 'faq/answer', :object => @question
      page.visual_effect :highlight, 'right'
    end
  end
    
  def new
    @sections = FaqSection.find(:all)
    @section = FaqSection.find_by_id(params[:id] || @sections.first)
    @question = Faq.new(:faq_section => @section)
    @question.faq_section_id = @section.id
  end

  def create
    # catch submit of new section action
      # does a question with this position already exist?
      if @question = Faq.find_by_position_and_faq_section_id(params["position"], params["faq_section_id"])
        @question.errors.add(:position, "is already used")
        return display_form_errors([@question]) if @question.errors.any?
      end
      
      @question = Faq.create(params["faq"])
      flash[:notice] = "Spørgsmål & svar er oprettet."
      
      redirect_to :action => 'index'
  end
  
  def edit
    @question = Faq.find(params[:id])
    @sections = FaqSection.find(:all)
    @section = @question.faq_section
    render :template => 'faqs/new'
  end
  
  def update
    @question = Faq.find(params[:id])
    @question.update_attributes(params[:faq])
    flash[:notice] = "Spørgsmål & svar er rettet."
    redirect_to faqs_path
  end
  
  def destroy
    @question = Faq.find(params[:id])
    if @question.destroy
      render :update do |page|
        page.visual_effect :highlight, "question_#{@question.id}"
        page.visual_effect :puff, "question_#{@question.id}"
      end
    end
  end

  def answer
    @question = Faq.find(params[:id])
    render :update do |page|
      page.replace_html 'right', :partial => 'answer', :object => @question
    end
  end
  
  def search
    @results = Faq.find_question(params[:search], current_user.domain_language)
    
    respond_to do |format|
      format.html { render(:update) do |page| page.replace_html 'right', :partial => 'search_results', :locals => {:questions => @questions} end }
    end
  end
end

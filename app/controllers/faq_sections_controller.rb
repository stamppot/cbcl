class FaqSectionsController < ApplicationController

  layout 'survey'
  
  # uses_tiny_mce(:options => {:theme => 'advanced',
  #   :browsers => %w{msie gecko safari},
  #   :theme_advanced_toolbar_location => "top",
  #   :theme_advanced_toolbar_align => "left",
  #   :theme_advanced_resizing => true,
  #   :theme_advanced_resize_horizontal => false,
  #   :paste_auto_cleanup_on_paste => true,
  #   :theme_advanced_buttons1 => %w{bold italic underline separator bullist numlist separator link unlink image undo redo},
  #   :theme_advanced_buttons2 => [],
  #   :theme_advanced_buttons3 => [],
  #   :convert_newlines_to_brs => true,
  #   :plugins => %w{contextmenu paste}})
    
  def index
    @sections = FaqSection.find(:all, :order => :position)
  end
  
  
  def new
    @section = FaqSection.new
  end
    
  # ajax-create section in form. update form with created section
  def create
    @section  = FaqSection.new(params[:faq_section])
    @section.save
    @sections = FaqSection.find(:all)
      
    flash[:notice] = "Nyt afsnit er oprettet."
    redirect_to faq_section_path
  end
  
  def edit
    @section = FaqSection.find(params[:id])
  end

  def update
    @section = FaqSection.find(params[:id])
    @section.update_attributes(params[:faq_section])
    
    flash[:notice] = "Afsnittet er rettet."
    redirect_to faqs_path
  end
  
  def destroy
    @section = FaqSection.find(params[:id])
    @section.destroy
    flash[:notice] = "Afsnittet er slettet."
    
    redirect_to faqs_path
  end
  
  def show
    @sections = [] << FaqSection.find(params[:id])
    render :template => 'faqs/index'
  end
  
  def order_questions
    @section = FaqSection.find(params[:id])
    @action = 'order'
    render :template => 'faq_sections/show'
  end
  
  def done_order_questions
    flash[:notice] = "Ny rækkefølge er gemt."
    render(:update) { |page| page.redirect_to faqs_path }
  end
  
  def sort_questions
    @section = FaqSection.find(params[:id]) 
    @section.faqs.each do |question| 
      question.position = params['question_list'].index(question.id.to_s) + 1 
      question.save 
    end 
    render :nothing => true 
  end
  
  # order sections
  def order
    @sections = FaqSection.find(:all, :order => :position)
    @action = 'order'
    render :template => 'faqs/list'
  end

  def sort
    @sections = FaqSection.find(:all) 
    @sections.each do |section|
      section.position = params['section_list'].index(section.id.to_s)+1
    end
    @sections.each { |section| section.save_without_validation! }

    render :nothing => true 
  end
  
  def done_order
    @sections = FaqSection.find(:all)
    flash[:notice] = "Ny rækkefølge er gemt."
    render(:update) { |page| page.redirect_to faqs_path }
  end

  def search
    @results = Faq.find_question(params[:search], current_user.domain_language)
    
    respond_to do |format|
      format.html { render(:update) do |page| page.replace_html 'right', :partial => 'search_results', :locals => {:questions => @questions} end }
    end
  end
end

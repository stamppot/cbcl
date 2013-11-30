class JournalEntriesController < ApplicationController # < ActiveRbac::ComponentController
  # The RbacHelper allows us to render +acts_as_tree+ AR elegantly
  helper RbacHelper
  
  before_filter :check_access

  # We force users to use POST on the state changing actions.
  verify :method       => "post",
         :only         => [ :remove, :remove_answer, :destroy_login ]

  def show
    journal_entry = JournalEntry.find(params[:id], :include => :journal)
    session[:journal_entry] = journal_entry.id
    cookies[:journal_entry] = journal_entry.id
    # logger.info "Setting session[:journal_entry] to #{journal_entry.id} for #{journal_entry.journal.title}"
    
    if params[:fast]
      redirect_to survey_show_fast_path(journal_entry.id) and return # caching disabled, so not .survey_id
    else
      redirect_to survey_path(journal_entry.survey_id) and return # using caching!
    end
  end

  def show_answer
    # puts "Show Answer JournalEntriesController #{params.inspect}"
    session[:journal_entry] = params[:id]
    journal_entry = JournalEntry.find(params[:id], :include => :journal)
    redirect_to survey_answer_path(journal_entry.survey_id)
  end

  # deletes and updates page with ajax call
  def remove
    elem = "entry" << params[:id]
    # must also remove login-user
    entry = JournalEntry.find(params[:id])
    entry.remove_login!
   
    if entry.destroy
      render :update do |page|
        page.remove elem
      end
    end
    rescue ActiveRecord::RecordNotFound
      flash[:error] = 'Skemaet kunne ikke findes.'
  end

  # remove an answer and the associated login-user. Remove entries from the journal_entry
  # TODO: nu sletter den svaret. Skal svaret ikke gemmes i anonym form, dvs. det skal ikke slettes, kun fra journalen?
  def remove_answer
    elem = "entry_answer" << params[:id]
    entry = JournalEntry.find(params[:id])
    # remove any score report created
    if entry.survey_answer
      sc = ScoreRapport.find_by_survey_answer_id(entry.survey_answer.id)
      sc.destroy if sc
    end

    # delete all answers and answer cells, delete login for journal_entry
    if entry.destroy
      render :update do |page|
        page.visual_effect :slide_up, elem
        page.remove elem
      end
    end
  end

  def edit # edit follow_up
    @journal_entry = JournalEntry.find(params[:id])
    @follow_ups
    @follow_ups = JournalEntry.follow_ups
  end

  def update
    @journal_entry = JournalEntry.find(params[:id])
    @journal_entry.follow_up = params[:journal_entry][:follow_up]
    @journal_entry.save
    redirect_to journal_path(@journal_entry.journal)
  end

  def edit_notes
    @journal_entry = JournalEntry.find(params[:id])
    @notes
  end

  def update_notes
    @journal_entry = JournalEntry.find(params[:id])
    @journal_entry.notes = params[:journal_entry][:notes]
    @journal_entry.save
    redirect_to journal_path(@journal_entry.journal)
  end

  protected
  
  def check_access
    if current_user and ((current_user.access?(:all_users) || current_user.access?(:login_user))) and params[:id]
      # j_id = JournalEntry.find(params[:id]).journal_id
      current_user.has_journal_entry? params[:id]
      # access = journal_ids.include? j_id
    end
    logger.info "check_access: params: #{params.inspect} cookie: #{cookies[:journal_entry]} session: #{session[:journal_entry]}"
    redirect_to login_path if !current_user
  end

end
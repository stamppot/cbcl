class JournalEntriesController < ApplicationController # < ActiveRbac::ComponentController
  # The RbacHelper allows us to render +acts_as_tree+ AR elegantly
  helper RbacHelper
  
  before_filter :check_access

  # We force users to use POST on the state changing actions.
  verify :method       => "post",
         :only         => [ :remove, :remove_answer, :destroy_login ]

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



  protected
  
  def check_access
    if current_user and ((current_user.access?(:all_users) || current_user.access?(:login_user))) and params[:id]
      j_id = JournalEntry.find(params[:id]).journal_id
      journal_ids = cache_fetch("journal_ids_user_#{current_user.id}") { current_user.journal_ids }
      access = journal_ids.include? j_id
    end
  end

  end
class JournalEntriesController < ApplicationController # < ActiveRbac::ComponentController
  # The RbacHelper allows us to render +acts_as_tree+ AR elegantly
  helper RbacHelper
  
  before_filter :check_access


  # We force users to use POST on the state changing actions.
  verify :method       => "post",
         :only         => [ :remove, :remove_answer, :destroy_login ]
  #        :redirect_to  => { :action => :list },
  #        :add_flash    => { :error => 'You sent an invalid request!' }
  #         
  #        # We force users to use GET on all other methods, though.
  #        verify :method => :get,
  #        :only         => [ :index, :list, :show, :new, :delete ],
  #        :redirect_to  => { :action => :list },
  #        :add_flash    => { :error => 'You sent an invalid request!' }


  # deletes and updates page with ajax call
  def remove
    elem = "entry" << params[:id]
    # must also remove login-user
    entry = JournalEntry.find(params[:id])
    entry.remove_login!
    puts "ELEM: #{elem}"
    if entry.destroy
      render :update do |page|
        page.visual_effect :puff, elem
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
    if entry.kill!
      render :update do |page|
        page[elem].visual_effect :puff
        page[elem].remove
      end
    end
  end

  def login_info
    @entry = JournalEntry.find(params[:id], :include => :login_user)
    @login_user = @entry.login_user
    render :layout => false
  end

  # deletes login-user and removes login_user from entry. :id specifies journal_entry
  # def destroy_login
  #   @entry = JournalEntry.find(params[:id].to_i)
  #   if not params[:yes].nil?
  #     @entry.remove_login!
  #     @entry.not_answered!
  #     flash[:notice] = 'Login-brugeren er slettet.'
  #   else
  #     flash[:notice] = 'Login-brugeren blev ikke fjernet fra denne journal.'
  #   end
  #   redirect_to journal_path(@entry.journal)
  #   
  # rescue ActiveRecord::RecordNotFound
  #   flash[:error] = 'Denne login-bruger kunne ikke findes.'
  #   redirect_to journal_path(@entry.journal)
  # end


  protected
  before_filter :user_access

  # Admin needs access to see subscriptions.. but this controller has no views, no?  
  def user_access
    if session[:rbac_user_id] and current_user.has_access? :all_users
      return true
    else
      redirect_to "/login"
      flash[:notice] = "Du har ikke adgang til denne side"
      return false
    end
  end
  
  def check_access
    if current_user and (current_user.has_access?(:all_users) || current_user.has_access?(:login_user)) and params[:id]
      j_id = JournalEntry.find(params[:id]).journal_id
      journal_ids = Rails.cache.fetch("journal_ids_user_#{current_user.id}") { current_user.journal_ids }
      access = journal_ids.include? j_id
    end
  end

  end
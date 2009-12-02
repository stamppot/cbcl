require File.dirname(__FILE__) + '/../test_helper'
require 'shoulda'
require 'journals_controller'

class JournalsControllerTest < ActiveSupport::TestCase

  login_as(:user1_101) do
    context "on GET to :list" do
      setup { 
        @controller = JournalController.new
        get :list
      }

      should_respond_with :success
      should_render_template :list
      should_not_set_the_flash
    end
  end

  login_as(:user1_101) do
    context "on GET to :show" do
      setup { 
        @controller = JournalController.new
        get :show, :id => 12 
      }

      should_respond_with :success
      should_render_template :show
      should_not_set_the_flash
    end
  end

  login_as(:user1_101) do
    context "on POST to :create" do
      params = {
        "person_info"=> {"birthdate(1i)"=>"2005", "birthdate(2i)"=>"6", "birthdate(3i)"=>"1", "sex"=>"2", "nationality"=>"Dansk"},
        "group"=>{"title"=>"Test person", "code"=>"4", "parent"=>"9"}
      }

      setup {
        @controller = JournalController.new
        post :create, params
      }

      should_assign_to :group
      should_change("Journal.count", :by => 1) { Journal.count }

      should_respond_with :redirect
      should_set_the_flash_to(/oprettet/i)
    end
  end

  login_as(:user1_101) do
    context "on GET to :edit" do
      params = {
        "id"=>"12"
      }

      setup {
        @controller = JournalController.new
        get :edit, params
      }

      should_assign_to :group
      should_assign_to :groups
      should_assign_to :person_info
      should_assign_to :nationalities

      should_respond_with :success
      should_render_template :edit
    end
  end
  
  login_as(:user1_101) do
    context "on POST to :update" do
      params = {
        "person_info"=>{"birthdate(1i)"=>"2004", "birthdate(2i)"=>"5", "birthdate(3i)"=>"30", "sex"=>"1", "nationality"=>"Dansk"},
        "id"=>"12", "group"=>{"title"=>"Test journal updated", "code"=>"1", "parent"=>"9"}
      }

      setup {
        @controller = JournalController.new
        post :update, params , :rbac_user_id => users(:user1_101).id
      }

      should_not_change("number of journals") { Journal.count }

      should_respond_with :redirect
      should_set_the_flash_to(/opdateret/i)
    end
  end
  
  # add (get/post) surveys to journal
  login_as(:user1_101) do
    context "on GET to :add_survey" do
      setup {
        @controller = JournalController.new
        get :add_survey, {"id"=>"12"}
      }

      should_assign_to :group
      should_assign_to :surveys
      should_assign_to :page_title

      should_respond_with :success
      should_render_template :add_survey
    end
  end
  
  login_as(:user1_101) do
    context "on POST to :add_survey" do
      setup {
        @controller = JournalController.new
        post :add_survey, {"id"=>"12", "survey"=>{"6"=>"0", "1"=>"1", "3"=>"1"}, "group"=>{"id"=>"12"}}
      }

      should_assign_to :surveys
      should_not_change("the number of journals") { Journal.count }
      should_change("add two journal entries and a login_user for each survey", :by => 2) { JournalEntry.count }
      should_change("add two login_users", :by => 2) { User.count }

      should_respond_with :redirect
      should_set_the_flash_to(/Spørgeskemaer blev tilføjet/i)
    end
  end

  # remove (get/post) surveys to journal
  login_as(:user1_101) do
    context "on GET to :remove_survey" do
      setup {
        @controller = JournalController.new
        get :remove_survey, {"id"=>"12"}
      }

      should_assign_to :group
      should_assign_to :entries
      should_not_change("any journal_entries") { JournalEntry.count }
      should_not_change("number of users") { User.count } # TODO: shouldn't this remove any login_users

      should_respond_with :success
      should_render_template :remove_survey
    end
  end
  
  login_as(:user1_101) do
    context "on POST to :remove_survey" do
      setup {
        @controller = JournalController.new
        @journala_101.create_journal_entries(Survey.find([1,2]))
        post :remove_survey, { "entry"=>{"6"=>"1", "13"=>"0", "5"=>"1"}, "id"=>"12" }
      }

      should_not_change("the journal") { Journal.count }
      # these do not work?!
      # should_change "JournalEntry.count", :by => -2 # => 2, :to => 0
      # should_change "User.count", :by => -2 #:from => 2, :to => 0

      should_respond_with :redirect
      should_set_the_flash_to(/Spørgeskemaer blev fjernet/i)
    end
  end
end
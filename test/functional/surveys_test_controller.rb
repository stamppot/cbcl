require File.dirname(__FILE__) + '/../test_helper'
require 'shoulda'

class SurveysControllerTest < ActiveSupport::TestCase

  login_as(:user_center1) do
    context "show CBCL 1,5-5 forældreskema on GET to :show_only successfully" do
      setup {
        @controller = SurveysController.new
        get :show_only, {:id => 1}
      }
  
      should_assign_to :survey
      should_respond_with :success
      # should_render_template :show
    end

    context "show CBCL 6-16 forældreskema on GET to :show_only successfully" do
      setup {
        @controller = SurveysController.new
        get :show_only, {:id => 2}
      }
  
      should_assign_to :survey
      should_respond_with :success
      # should_render_template :show
    end

    context "show C-TRF 1,5-5 lærerskema on GET to :show_only successfully" do
      setup {
        @controller = SurveysController.new
        get :show_only, {:id => 3}
      }
  
      should_assign_to :survey
      should_respond_with :success
      # should_render_template :show
    end

    context "show TRF 6-16 lærerskema on GET to :show_only successfully" do
      setup {
        @controller = SurveysController.new
        get :show_only, {:id => 4}
      }
  
      should_assign_to :survey
      should_respond_with :success
      should_render_template :show
    end

    context "show YSR 6-16 ungskema on GET to :show_only successfully" do
      setup {
        @controller = SurveysController.new
        get :show_only, {:id => 5}
      }
  
      should_assign_to :survey
      should_respond_with :success
      should_render_template :show
    end

  end
end
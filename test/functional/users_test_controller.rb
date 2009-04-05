require File.dirname(__FILE__) + '/../test_helper'
require 'shoulda'

class UsersControllerTest < Test::Unit::TestCase

  # user behandler should have a role, a center (a group)
  login_as(:user_center1) do
    context "on POST to :create successfully" do
      setup {
        params = {
          "user"=>{"roles"=>[roles(:behandler).id], "name"=>"Behandler Testesen",
            "groups"=>[groups(:team101).id],
            "login"=>"test behandler", "state"=>"2", "email"=>"test@behandler",
            "password_confirmation"=>"testpassword", "password"=>"testpassword"
          }}        
        @controller = ActiveRbac::UserController.new
        post :create, params
      }
  
      should_set_the_flash_to(/Brugeren blev oprettet/i)
      should_assign_to :user
      should_respond_with :success
      should_render_template :show
    end
  end
  
  # same as above but without center!
  # user behandler should have a role, a center (a group)
  login_as(:user_center1) do
    context "on POST to :create without group" do
      setup {
        params = {
          "user"=>{"roles"=>[roles(:behandler).id], "name"=>"Behandler Testesen",
            # "groups"=>[groups(:team101).id],
            "login"=>"test behandler", "state"=>"2", "email"=>"test@behandler",
            "password_confirmation"=>"testpassword", "password"=>"testpassword"
          }}       
        @controller = ActiveRbac::UserController.new
        post :create, params
      }
  
      should_assign_to :user
      should_respond_with :success
      should_render_template :new
    end
  end
  
  # same, but without role
  # user behandler should have a role, a center (a group)
  login_as(:user_center1) do
    context "on POST to :create without role" do
      setup {
        params = {
          "user"=>{"name"=>"Behandler Testesen", # no roles
            "groups"=>[groups(:team101).id],
            "login"=>"test behandler", "state"=>"2", "email"=>"test@behandler",
            "password_confirmation"=>"testpassword", "password"=>"testpassword"
          }}       
        @controller = ActiveRbac::UserController.new
        post :create, params
      }
  
      should_assign_to :user
      should_respond_with :success
      should_render_template :new
    end
  end


  # user behandler should have a role, a center (a group)
  login_as(:user_center1) do
    context "on POST to :update successfully" do
      setup do
        params = { "id" => users(:user1_101).id,
          "user"=>{"roles"=>[roles(:behandler).id], "name"=>"Behandler Testesen",
            "groups"=>[groups(:team101).id],
            "login"=>"test behandler", "state"=>"2", "email"=>"test@behandler",
            "password_confirmation"=>"testpassword", "password"=>"testpassword"
          }}        
        @controller = ActiveRbac::UserController.new
        post :update, params
      end

      # should_set_the_flash_to(/Brugeren/i)
      should_respond_with :success
      should_render_template :show
    end
  end

  # same as above but without center!
  # user behandler should have a role, a center (a group)
  login_as(:user_center1) do
    context "on POST to :update without group" do
      setup {
        params = { "id" => users(:user1_101).id,
          "user"=>{"roles"=>[roles(:behandler).id], "name"=>"Behandler Testesen",
            # "groups"=>[groups(:team101).id],
            "login"=>"test behandler", "state"=>"2", "email"=>"test@behandler",
            "password_confirmation"=>"testpassword", "password"=>"testpassword"
          }}
        @controller = ActiveRbac::UserController.new
        post :update, params
      }
  
      should_respond_with :success
      should_render_template :edit
    end
  end
  
  # same, but without role
  # user behandler should have a role, a center (a group)
  login_as(:user_center1) do
    context "on POST to :update without role" do
      setup {
        params = { "id" => users(:user1_101).id,
          "user"=>{"name"=>"Behandler Testesen", # no roles
            "groups"=>[groups(:team101).id],
            "login"=>"test behandler", "state"=>"2", "email"=>"test@behandler",
            "password_confirmation"=>"testpassword", "password"=>"testpassword"
          }}
        @controller = ActiveRbac::UserController.new
        post :update, params
      }
  
      should_respond_with :success
      should_render_template :edit
    end
  end
end
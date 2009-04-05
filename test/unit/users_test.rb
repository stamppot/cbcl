require File.dirname(__FILE__) + '/../test_helper'
require 'shoulda'

class UsersTest < Test::Unit::TestCase #ActiveSupport::TestCase

  fixtures :groups, :roles
  
  def setup
  end
  
  def teardown
  end

  context "Create user" do
    context "with perfect parameters" do
      setup do
        params = {:roles => [roles(:behandler)], :name =>"behandler test 1", :groups =>[groups(:team101).id],
             :login =>"test 22222", :state =>"2", :email =>"behandler22222@test.dk",
             :password_confirmation => "a_password", :password =>"a_password"}
        @user = users(:user_superadmin).create_user(params)  # current_user should pass on roles/groups. TODO: fix
      end
      should "have no errors when validating" do
        assert @user.valid?
      end
    end
  
    context "without role parameter" do
      setup do
        params = {:name=>"behandler test 1", :groups =>[groups(:team101).id],
             :login=>"test 22222", :state=>"2", :email=>"behandler22222@test.dk",
             :password_confirmation=>"a_password", :password=>"a_password"}
        @user = users(:user_superadmin).create_user(params)
      end
      should "fail on role" do
        assert !@user.valid?
        assert_equal "skal angives", @user.errors["roles"]
      end
    end
    
    context "without group parameter" do
      setup do
        params = {:roles =>[roles(:behandler)], :name=>"behandler test 1", # no group: :groups=>[groups(:team101).id],
             :login=>"test 22222", :state=>"2", :email=>"behandler22222@test.dk",
             :password_confirmation=>"a_password", :password=>"a_password"}
        @user = users(:user_superadmin).create_user(params)
      end
      should "fail on group" do
        assert !@user.valid?
      end
    end
  end
  
  context "Update user" do
    context "with perfect parameters" do
      setup do
        params = {:roles => [roles(:behandler)], :name =>"behandler test 1", :groups =>[groups(:team101).id],
             :login =>"test 22222", :state =>"2", :email =>"behandler22222@test.dk",
             :password_confirmation => "a_password", :password =>"a_password"}
        @user = User.find(22)
        users(:user_superadmin).update_user(@user, params)
      end
      should "have no errors when validating" do
        assert @user.valid?
      end
    end
  end
  
  
  ### ACCESS ETC METHODS

  context "behandler" do
    setup do
      @user = users(:user1_101)
      @behandler_role = [roles(:behandler)]
      @teamadmin_role = [roles(:teamadministrator)] 
      @centeradmin_role = [roles(:centeradministrator)]
      @admin_role = [roles(:admin)]
      @superadmin_role = [roles(:superadmin)]
      # params = {:roles => [roles(:behandler)], :name =>"behandler test 1", :groups =>[groups(:team101).id],
      #      :login =>"test 22222", :state =>"2", :email =>"behandler22222@test.dk",
      #      :password_confirmation => "a_password", :password =>"a_password"}
      # @user = users(:user_superadmin).create_user(params)  # current_user should pass on roles/groups. TODO: fix
    end
    should "have access to behandler role" do assert @user.access_to_roles?(@behandler_role) end
    should "have no access to teamadmin role" do assert !@user.access_to_roles?(@teamadmin_role) end
    should "have no access to centeradmin role" do assert !@user.access_to_roles?(@centeradmin_role) end
    should "have no access to admin role" do assert !@user.access_to_roles?(@admin_role) end
    should "have no access to superadmin role" do assert !@user.access_to_roles?(@superadmin_role) end
  end

  context "teamadmin" do
    setup do
      @user = users(:teamadmin_101)
      @behandler_role = [roles(:behandler)]
      @teamadmin_role = [roles(:teamadministrator)] 
      @centeradmin_role = [roles(:centeradministrator)]
      @admin_role = [roles(:admin)]
      @superadmin_role = [roles(:superadmin)]
      @own_roles = @behandler_role + @teamadmin_role
    end
    should "have access to behandler role" do assert @user.access_to_roles?(@behandler_role) end
    should "have access to teamadmin role" do assert @user.access_to_roles?(@teamadmin_role) end
    should "have no access to centeradmin role" do assert !@user.access_to_roles?(@centeradmin_role) end
    should "have no access to admin role" do assert !@user.access_to_roles?(@admin_role) end
    should "have no access to superadmin role" do assert !@user.access_to_roles?(@superadmin_role) end
    should "have access to inherited roles" do assert @user.access_to_roles?(@own_roles) end
  end
  
  context "centeradmin" do
    setup do
      @user = users(:user_center1)
      @behandler_role = [roles(:behandler)]
      @teamadmin_role = [roles(:teamadministrator)] 
      @centeradmin_role = [roles(:centeradministrator)]
      @admin_role = [roles(:admin)]
      @superadmin_role = [roles(:superadmin)]
      @own_roles = @behandler_role + @teamadmin_role
    end
    should "have access to behandler role" do assert @user.access_to_roles?(@behandler_role) end
    should "have access to teamadmin role" do assert @user.access_to_roles?(@teamadmin_role) end
    should "have access to centeradmin role" do assert @user.access_to_roles?(@centeradmin_role) end
    should "have no access to admin role" do assert !@user.access_to_roles?(@admin_role) end
    should "have no access to superadmin role" do assert !@user.access_to_roles?(@superadmin_role) end
    should "have access to inherited roles" do assert @user.access_to_roles?(@own_roles) end
  end
  
  context "admin" do
    setup do
      @user = users(:user_admin)
      @behandler_role = [roles(:behandler)]
      @teamadmin_role = [roles(:teamadministrator)] 
      @centeradmin_role = [roles(:centeradministrator)]
      @admin_role = [roles(:admin)]
      @superadmin_role = [roles(:superadmin)]
    end
    should "have access to own role" do assert @user.access_to_roles?(@admin_role) end
    should "have no access to behandler role" do assert !@user.access_to_roles?(@behandler_role) end
    should "have no access to teamadmin role" do assert !@user.access_to_roles?(@teamadmin_role) end
    should "have no access to centeradmin role" do assert !@user.access_to_roles?(@centeradmin_role) end
    should "have access to admin role" do assert @user.access_to_roles?(@admin_role) end
    should "have no access to superadmin role" do assert !@user.access_to_roles?(@superadmin_role) end
  end
  
  context "superadmin" do
    setup do
      @user = users(:user_superadmin)
      @behandler_role = [roles(:behandler)]
      @teamadmin_role = [roles(:teamadministrator)] 
      @centeradmin_role = [roles(:centeradministrator)]
      @admin_role = [roles(:admin)]
      @superadmin_role = [roles(:superadmin)]
      @own_roles = @behandler_role + @teamadmin_role + @admin_role + @superadmin_role
    end
    should "have access to own role" do assert @user.access_to_roles?(@admin_role) end
    should "have access to behandler role" do assert @user.access_to_roles?(@behandler_role) end
    should "have access to teamadmin role" do assert @user.access_to_roles?(@teamadmin_role) end
    should "have access to centeradmin role" do assert @user.access_to_roles?(@centeradmin_role) end
    should "have access to admin role" do assert @user.access_to_roles?(@admin_role) end
    should "have access to superadmin role" do assert @user.access_to_roles?(@superadmin_role) end
  end

  def test_login_users
    # for normal user
    @user1_101.login_users.each do |login_user|
      assert login_user.login_user?
    end
    # for centeradmin
    @user1_101.login_users.each do |login_user|
      assert login_user.login_user?
    end
  end
  
  def test_user_can_pass_on_own_roles
    # @user1_101 is a behandler, can only pass on this role
    assert_all [Role.get(:behandler)], @user1_101.pass_on_roles

    # @user1_101 should have none of these roles
    all_other_roles = Role.all.delete_if {|r| r.title == "behandler" }
    assert_none @user1_101.pass_on_roles, all_other_roles
    # center user is center admin, but can pass on lower roles, too
    assert_all @user_center2.roles, [Role.get(:centeradministrator)]
    assert_all @user_center2.pass_on_roles, Role.get(:centeradministrator, :teamadministrator, :behandler)
  end
  
  # superadmins can see all users
  # admin can see no users in centers or centeradmins (so only other admins)
  # centeradministrators can see all users in center
  # behandlere can see all users in member (own) teams, but no users in other teams
  def test_get_users
    # superadmin
    users = @user_superadmin.get_users
    assert users.include?(@user_superadmin)
    assert users.include?(@user_superadmin2)
    assert users.include?(@user_admin)
    assert users.include?(@user1_101) 
    assert users.include?(@user2_101)
    assert users.include?(@user1_102)
    assert users.include?(@user2_102)
    assert users.include?(@user_center1) 
    assert users.include?(@user1_201) 
    assert users.include?(@user2_201)
    assert users.include?(@user1_202)
    assert users.include?(@user2_202)
    assert users.include?(@user_center2) 
    
    # admin can see no users!
    users = @user_admin.get_users
    assert users.include?(@user_admin)
    assert !users.include?(@user_superadmin)
    assert !users.include?(@user_superadmin2)
    assert !users.include?(@user2_101)
    assert !users.include?(@user1_102)
    assert !users.include?(@user2_102)
    assert !users.include?(@user_center1) 
    assert !users.include?(@user1_201) 
    assert !users.include?(@user2_201)
    assert !users.include?(@user1_202)
    assert !users.include?(@user2_202)
    assert !users.include?(@user_center2) 
    
    # centeradministrator
    users = @user_center1.get_users
    assert users.include?(@user1_101) 
    assert users.include?(@user2_101)
    assert users.include?(@user1_102)
    assert users.include?(@user2_102)
    assert users.include?(@user_center1) 
    
    # behandler
    users = @user1_101.get_users
    assert users.include?(@user1_101) 
    assert users.include?(@user2_101)
    assert users.include?(@user1_102)
    assert users.include?(@user2_102)
    assert users.include?(@user_center1) 

    # centeradministrator center 2
    users = @user_center2.get_users
    assert users.include?(@user1_201) 
    assert users.include?(@user2_201)
    assert users.include?(@user1_202)
    assert users.include?(@user2_202)
    assert users.include?(@user_center2) 
    
    # behandler center 2
    # behandlere can see all users in member (own) teams, not in other teams
    users = @user2_201.get_users
    assert users.include?(@user1_201) 
    assert users.include?(@user2_201)
    assert users.include?(@user1_202)
    assert users.include?(@user2_202)
    assert users.include?(@user_center2) 
  end
end
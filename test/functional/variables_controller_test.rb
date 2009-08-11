require 'test_helper'

class VariablesControllerTest < ActionController::TestCase

  def setup
    login_as(users(:user_superadmin))
  end
  
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:variables)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create variable" do
    assert_difference('Variable.count') do
      post :create, :variable => { :var => 'ccyhob', :row => 2, :col => 2, :question_id => 1, :survey_id => 1}
    end

    assert_response :success
  end

  test "should show variable" do
    get :show, :id => variables(:one).id
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => variables(:one).id
    assert_response :success
  end

  test "should update variable" do
    put :update, :id => variables(:one).id, :variable => { }
    assert_response :success
  end

  test "should destroy variable" do
    assert_difference('Variable.count', -1) do
      delete :destroy, :id => variables(:one).id
    end

    assert_redirected_to variables_path
  end
end

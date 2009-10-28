require 'test_helper'

class SubscriptionsControllerTest < ActiveSupport::TestCase

  def setup
    self.login_as(users(:user_superadmin))
  end
  
  test "should get index" do
    get :index
    assert_response :success
  end

end
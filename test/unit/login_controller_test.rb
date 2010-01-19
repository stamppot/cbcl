require "cacheable_flash/test_helpers"

class ControllerTest < Test::Unit::TestCase
  include CacheableFlash::TestHelpers

  def setup
    @controller = LoginController.new
    @request = ActionController::TestRequest.new
    @response = ActionController::TestResponse.new
  end

  def test_cacheable_flash_action
    get :login
    asset_equal 'Forkert brugernavn eller password', flash_cookie["error"]
  end
end
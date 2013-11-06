require 'test_helper'

class PlayersControllerTest < ActionController::TestCase
  test "should get get_player" do
    get :get_player
    assert_response :success
  end

end

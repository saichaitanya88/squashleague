require 'test_helper'

class LeagueControllerTest < ActionController::TestCase
  test "should get home" do
    get :home
    assert_response :success
  end

  test "should get players" do
    get :players
    assert_response :success
  end

  test "should get schedule" do
    get :schedule
    assert_response :success
  end

  test "should get player_history" do
    get :player_history
    assert_response :success
  end

  test "should get history" do
    get :history
    assert_response :success
  end

end

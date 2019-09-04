require 'test_helper'

class LedsControllerTest < ActionDispatch::IntegrationTest
  test "should get on" do
    get leds_on_url
    assert_response :success
  end

  test "should get off" do
    get leds_off_url
    assert_response :success
  end

end

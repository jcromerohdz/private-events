require 'test_helper'

class EventsControllerTest < ActionDispatch::IntegrationTest
  # test "the truth" do
  #   assert true
  # end
  # get "/photos/10/style/cool"

  test "should get events" do
    get events_url
    assert_response :success
  end


end

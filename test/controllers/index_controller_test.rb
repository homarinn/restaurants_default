require 'test_helper'

class IndexControllerTest < ActionDispatch::IntegrationTest
  test "should get search" do
    get index_search_url
    assert_response :success
  end

end

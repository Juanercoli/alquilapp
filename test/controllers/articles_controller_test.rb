require "test_helper"

class ArticlesControllerTest < ActionDispatch::IntegrationTest
  test "should get index1" do
    get articles_index1_url
    assert_response :success
  end
end

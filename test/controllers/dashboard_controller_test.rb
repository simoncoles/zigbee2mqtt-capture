require "test_helper"

class DashboardControllerTest < ActionDispatch::IntegrationTest
  test "GET / returns 200" do
    get root_path
    assert_response :success
  end
end

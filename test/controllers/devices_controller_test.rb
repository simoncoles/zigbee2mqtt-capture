require "test_helper"

class DevicesControllerTest < ActionDispatch::IntegrationTest
  test "GET /devices returns 200" do
    get devices_path
    assert_response :success
  end

  test "GET /devices with search param works" do
    get devices_path, params: { q: "Living Room" }
    assert_response :success
  end
end

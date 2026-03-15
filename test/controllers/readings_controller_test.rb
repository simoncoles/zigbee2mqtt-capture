require "test_helper"

class ReadingsControllerTest < ActionDispatch::IntegrationTest
  test "GET /readings returns 200" do
    get readings_path
    assert_response :success
  end

  test "GET /readings with search param works" do
    get readings_path, params: { q: "temperature" }
    assert_response :success
  end
end

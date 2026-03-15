require "test_helper"

class MqttMessagesControllerTest < ActionDispatch::IntegrationTest
  test "GET /mqtt_messages returns 200" do
    get mqtt_messages_path
    assert_response :success
  end

  test "GET /mqtt_messages with search param works" do
    get mqtt_messages_path, params: { q: "zigbee2mqtt" }
    assert_response :success
  end
end

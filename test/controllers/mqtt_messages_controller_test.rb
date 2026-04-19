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

  test "GET /mqtt_messages/system returns 200" do
    get system_mqtt_messages_path
    assert_response :success
  end

  test "GET /mqtt_messages/system with search param works" do
    get system_mqtt_messages_path, params: { q: "bridge" }
    assert_response :success
  end

  test "GET /mqtt_messages/commands returns 200" do
    get commands_mqtt_messages_path
    assert_response :success
  end

  test "GET /mqtt_messages/commands with search param works" do
    get commands_mqtt_messages_path, params: { q: "Garage Light" }
    assert_response :success
  end
end

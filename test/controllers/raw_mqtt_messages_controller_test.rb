require "test_helper"

class RawMqttMessagesControllerTest < ActionDispatch::IntegrationTest
  test "GET /raw_mqtt_messages returns 200" do
    get raw_mqtt_messages_path
    assert_response :success
    assert_match "Raw MQTT Messages", response.body
    assert_match "homeassistant/status", response.body
  end

  test "GET /raw_mqtt_messages with search narrows results" do
    get raw_mqtt_messages_path, params: { q: "weather" }
    assert_response :success
    assert_match "weather/outside/temperature", response.body
    assert_no_match(/homeassistant\/status/, response.body)
  end

  test "GET /raw_mqtt_messages/:id returns 200" do
    get raw_mqtt_message_path(raw_mqtt_messages(:ha_online))
    assert_response :success
    assert_match "homeassistant/status", response.body
    assert_match "online", response.body
  end
end

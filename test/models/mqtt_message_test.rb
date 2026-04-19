require "test_helper"

class MqttMessageTest < ActiveSupport::TestCase
  # -- Associations --

  test "belongs to device" do
    message = mqtt_messages(:motion_event)
    assert_equal devices(:motion_sensor), message.device
  end

  test "device is optional" do
    message = mqtt_messages(:bridge_state)
    assert_nil message.device
    assert message.valid?
  end

  test "has many readings" do
    message = mqtt_messages(:motion_event)
    assert_respond_to message, :readings
    assert_includes message.readings, readings(:motion_occupancy)
  end

  # -- Scopes --

  test "search matches topic" do
    results = MqttMessage.search("zigbee2mqtt/Living")
    assert_includes results, mqtt_messages(:motion_event)
    assert_not_includes results, mqtt_messages(:temp_reading)
  end

  test "search matches friendly_name" do
    results = MqttMessage.search("Kitchen Temperature")
    assert_includes results, mqtt_messages(:temp_reading)
  end

  test "search matches content" do
    results = MqttMessage.search("occupancy")
    assert_includes results, mqtt_messages(:motion_event)
  end

  test "search returns all when blank" do
    assert_equal MqttMessage.count, MqttMessage.search("").count
    assert_equal MqttMessage.count, MqttMessage.search(nil).count
  end

  test "device_messages scope returns only device category" do
    results = MqttMessage.device_messages
    assert results.all? { |m| m.category == "device" }
    assert_includes results, mqtt_messages(:motion_event)
    assert_not_includes results, mqtt_messages(:bridge_state)
  end

  test "non_device_messages scope excludes device category" do
    results = MqttMessage.non_device_messages
    assert results.none? { |m| m.category == "device" }
    assert_includes results, mqtt_messages(:bridge_state)
    assert_includes results, mqtt_messages(:availability_update)
  end

  # -- categorize_topic --

  test "categorize_topic returns bridge for bridge topics" do
    assert_equal "bridge", MqttMessage.categorize_topic("zigbee2mqtt/bridge/state")
    assert_equal "bridge", MqttMessage.categorize_topic("zigbee2mqtt/bridge/logging")
  end

  test "categorize_topic returns availability for availability topics" do
    assert_equal "availability", MqttMessage.categorize_topic("zigbee2mqtt/Living Room Motion/availability")
  end

  test "categorize_topic returns system for other topics" do
    assert_equal "system", MqttMessage.categorize_topic("zigbee2mqtt/unknown_thing")
  end

  test "categorize_topic works with alternate zigbee prefixes" do
    assert_equal "bridge", MqttMessage.categorize_topic("zigbee-shed/bridge/state")
    assert_equal "availability", MqttMessage.categorize_topic("zigbee-conservatory/Back Door/availability")
  end

  # -- formatted_json_pre --

  test "formatted_json_pre returns escaped HTML pre block" do
    message = mqtt_messages(:motion_event)
    html = message.formatted_json_pre
    assert_includes html, "<pre"
    assert_includes html, "</pre>"
    assert_includes html, "occupancy"
  end

  test "formatted_json_pre returns empty string when formatted_json is nil" do
    message = mqtt_messages(:light_status_1)
    assert_equal "", message.formatted_json_pre
  end

  test "formatted_json_pre html-escapes special characters" do
    message = mqtt_messages(:motion_event)
    message.formatted_json = '<script>alert("xss")</script>'
    html = message.formatted_json_pre
    assert_not_includes html, "<script>"
    assert_includes html, "&lt;script&gt;"
  end
end

require "test_helper"

class MqttTopicTest < ActiveSupport::TestCase
  test "topic_handled? is true for zigbee-prefixed topics" do
    assert MqttTopic.topic_handled?("zigbee2mqtt/Living Room Motion")
    assert MqttTopic.topic_handled?("zigbee-shed/bridge/state")
    assert MqttTopic.topic_handled?("zigbee-conservatory/Thing/availability")
  end

  test "topic_handled? is false for other prefixes and blank input" do
    assert_not MqttTopic.topic_handled?("homeassistant/status")
    assert_not MqttTopic.topic_handled?("weather/outside/temperature")
    assert_not MqttTopic.topic_handled?("")
    assert_not MqttTopic.topic_handled?(nil)
  end

  test "record_seen! creates a new topic with correct handled flag" do
    topic = MqttTopic.record_seen!("homeassistant/newthing")

    assert topic.persisted?
    assert_equal "homeassistant/newthing", topic.name
    assert_not topic.handled
    assert_equal 1, topic.reload.message_count
  end

  test "record_seen! creates zigbee topics with handled=true" do
    topic = MqttTopic.record_seen!("zigbee2mqtt/NewSensor")
    assert topic.handled
  end

  test "record_seen! bumps message_count and last_seen_at on subsequent calls" do
    first  = 2.hours.ago
    later  = 1.minute.ago
    topic  = MqttTopic.record_seen!("weather/new", now: first)
    starting_count = topic.reload.message_count

    MqttTopic.record_seen!("weather/new", now: later)

    topic.reload
    assert_equal starting_count + 1, topic.message_count
    assert_in_delta later, topic.last_seen_at, 1.second
  end

  test "handled and unhandled scopes partition rows" do
    handled_names   = MqttTopic.handled.pluck(:name)
    unhandled_names = MqttTopic.unhandled.pluck(:name)

    assert_includes handled_names, "zigbee2mqtt/Living Room Motion"
    assert_includes unhandled_names, "homeassistant/status"
    assert_not_includes handled_names, "homeassistant/status"
  end

  test "search matches by topic name" do
    results = MqttTopic.search("weather").pluck(:name)
    assert_includes results, "weather/outside/temperature"
    assert_not_includes results, "homeassistant/status"
  end
end

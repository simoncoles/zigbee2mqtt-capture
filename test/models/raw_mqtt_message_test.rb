require "test_helper"

class RawMqttMessageTest < ActiveSupport::TestCase
  test "requires a mqtt_topic" do
    msg = RawMqttMessage.new(topic: "x/y", payload: "z")
    assert_not msg.valid?
    assert msg.errors[:mqtt_topic].any?
  end

  test "search matches by topic and payload" do
    topic_results   = RawMqttMessage.search("homeassistant").pluck(:topic)
    payload_results = RawMqttMessage.search("offline").pluck(:payload)

    assert_includes topic_results, "homeassistant/status"
    assert_includes payload_results, "offline"
  end

  test "blank search returns all rows" do
    assert_equal RawMqttMessage.count, RawMqttMessage.search(nil).count
    assert_equal RawMqttMessage.count, RawMqttMessage.search("").count
  end
end

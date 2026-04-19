require "test_helper"

class MqttTopicsControllerTest < ActionDispatch::IntegrationTest
  test "GET /mqtt_topics lists all topics by default" do
    get mqtt_topics_path
    assert_response :success
    assert_match "zigbee2mqtt/Living Room Motion", response.body
    assert_match "homeassistant/status", response.body
    assert_match "weather/outside/temperature", response.body
  end

  test "GET /mqtt_topics?filter=unhandled excludes handled topics" do
    get mqtt_topics_path, params: { filter: "unhandled" }
    assert_response :success
    assert_match "homeassistant/status", response.body
    assert_match "weather/outside/temperature", response.body
    assert_no_match(/zigbee2mqtt\/Living Room Motion/, response.body)
  end

  test "GET /mqtt_topics with search narrows results" do
    get mqtt_topics_path, params: { q: "weather" }
    assert_response :success
    assert_match "weather/outside/temperature", response.body
    assert_no_match(/homeassistant\/status/, response.body)
  end

  test "GET /mqtt_topics combines filter and search" do
    get mqtt_topics_path, params: { filter: "unhandled", q: "home" }
    assert_response :success
    assert_match "homeassistant/status", response.body
    assert_no_match(/weather\/outside\/temperature/, response.body)
    assert_no_match(/zigbee2mqtt\/Living Room Motion/, response.body)
  end

  test "GET /mqtt_topics/:id shows topic details and its messages" do
    topic = mqtt_topics(:home_assistant_status)
    get mqtt_topic_path(topic)
    assert_response :success
    assert_match "homeassistant/status", response.body
    assert_match "online", response.body
    assert_match "offline", response.body
    assert_no_match(/weather\/outside\/temperature/, response.body)
  end
end

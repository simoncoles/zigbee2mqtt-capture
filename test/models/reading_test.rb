require "test_helper"

class ReadingTest < ActiveSupport::TestCase
  # -- Associations --

  test "belongs to mqtt_message" do
    reading = readings(:temp_temperature)
    assert_equal mqtt_messages(:temp_reading), reading.mqtt_message
  end

  test "belongs to device" do
    reading = readings(:temp_temperature)
    assert_equal devices(:temp_sensor), reading.device
  end

  # -- Scopes --

  test "search matches key" do
    results = Reading.search("temperature")
    assert_includes results, readings(:temp_temperature)
    assert_not_includes results, readings(:motion_occupancy)
  end

  test "search matches value" do
    results = Reading.search("22.5")
    assert_includes results, readings(:temp_temperature)
  end

  test "search matches device friendly_name" do
    results = Reading.search("Kitchen")
    assert_includes results, readings(:temp_temperature)
    assert_not_includes results, readings(:motion_occupancy)
  end

  test "search returns all when blank" do
    assert_equal Reading.count, Reading.search("").count
    assert_equal Reading.count, Reading.search(nil).count
  end
end

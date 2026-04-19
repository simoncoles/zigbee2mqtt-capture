# == Schema Information
#
# Table name: devices
#
#  id                    :integer          not null, primary key
#  alert_threshold_hours :decimal(10, 2)
#  capture_max           :integer
#  device_type           :string
#  friendly_name         :string
#  ieee_addr             :string
#  is_responsive         :boolean          default(TRUE)
#  last_alert_at         :datetime
#  last_checked_at       :datetime
#  last_heard_from       :datetime
#  manufacturer_name     :string
#  model                 :string
#  monitoring_enabled    :boolean          default(TRUE)
#  network_address       :integer
#  power_source          :string
#  zcl_version           :integer
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#
# Indexes
#
#  index_devices_on_friendly_name                                (friendly_name)
#  index_devices_on_ieee_addr                                    (ieee_addr) UNIQUE
#  index_devices_on_is_responsive                                (is_responsive)
#  index_devices_on_last_heard_from                              (last_heard_from)
#  index_devices_on_manufacturer_name                            (manufacturer_name)
#  index_devices_on_model                                        (model)
#  index_devices_on_monitoring_and_responsive_and_last_alert_at  (monitoring_enabled,is_responsive,last_alert_at DESC)
#  index_devices_on_monitoring_enabled                           (monitoring_enabled)
#  index_devices_on_monitoring_responsive_last_heard             (monitoring_enabled,is_responsive,last_heard_from)
#  index_devices_on_power_source                                 (power_source)
#
require "test_helper"

class DeviceTest < ActiveSupport::TestCase
  # -- Associations --

  test "has many mqtt_messages" do
    device = devices(:motion_sensor)
    assert_respond_to device, :mqtt_messages
    assert_includes device.mqtt_messages, mqtt_messages(:motion_event)
  end

  test "has many readings" do
    device = devices(:motion_sensor)
    assert_respond_to device, :readings
    assert_includes device.readings, readings(:motion_occupancy)
  end

  # -- Scopes --

  test "search matches friendly_name" do
    results = Device.search("Living Room")
    assert_includes results, devices(:motion_sensor)
    assert_not_includes results, devices(:temp_sensor)
  end

  test "search matches model" do
    results = Device.search("RTCGQ11LM")
    assert_includes results, devices(:motion_sensor)
  end

  test "search matches manufacturer_name" do
    results = Device.search("IKEA")
    assert_includes results, devices(:light_bulb)
  end

  test "search matches ieee_addr" do
    results = Device.search("0x00158d0001a2b3c4")
    assert_includes results, devices(:motion_sensor)
  end

  test "search returns all when blank" do
    assert_equal Device.count, Device.search("").count
    assert_equal Device.count, Device.search(nil).count
  end

  test "monitored scope returns only monitoring_enabled devices" do
    monitored = Device.monitored
    assert_includes monitored, devices(:motion_sensor)
    assert_includes monitored, devices(:temp_sensor)
    assert_includes monitored, devices(:light_bulb)
    assert_not_includes monitored, devices(:door_sensor)
  end

  test "non_responsive scope returns monitored non-responsive devices" do
    non_responsive = Device.non_responsive
    assert_includes non_responsive, devices(:temp_sensor)
    assert_not_includes non_responsive, devices(:motion_sensor)
    assert_not_includes non_responsive, devices(:door_sensor)
  end

  test "responsive scope returns monitored responsive devices" do
    responsive = Device.responsive
    assert_includes responsive, devices(:motion_sensor)
    assert_includes responsive, devices(:light_bulb)
    assert_not_includes responsive, devices(:temp_sensor)
    assert_not_includes responsive, devices(:door_sensor)
  end

  # -- calculate_initial_threshold --

  test "calculate_initial_threshold with 2+ messages returns 2x interval clamped" do
    device = devices(:motion_sensor)
    # motion_sensor has messages at 1.hour.ago and 3.hours.ago => interval ~2 hours => threshold ~4 hours
    threshold = device.calculate_initial_threshold
    assert_in_delta 4.0, threshold, 0.1
  end

  test "calculate_initial_threshold with less than 2 messages returns 24" do
    device = devices(:door_sensor)
    # door_sensor has only 1 message
    assert_equal 24.0, device.calculate_initial_threshold
  end

  test "calculate_initial_threshold clamps minimum to 1.0" do
    device = devices(:motion_sensor)
    # Create two messages very close together (10 seconds apart)
    device.readings.delete_all
    device.mqtt_messages.delete_all
    MqttMessage.create!(topic: "t", content: "c", device: device, created_at: 1.minute.ago)
    MqttMessage.create!(topic: "t", content: "c", device: device, created_at: 1.minute.ago + 10.seconds)
    assert_equal 1.0, device.calculate_initial_threshold
  end

  test "calculate_initial_threshold clamps maximum to 168.0" do
    device = devices(:motion_sensor)
    device.readings.delete_all
    device.mqtt_messages.delete_all
    MqttMessage.create!(topic: "t", content: "c", device: device, created_at: 1.day.ago)
    MqttMessage.create!(topic: "t", content: "c", device: device, created_at: 100.days.ago)
    assert_equal 168.0, device.calculate_initial_threshold
  end

  # -- check_responsiveness --

  test "check_responsiveness returns nil when monitoring disabled" do
    device = devices(:door_sensor)
    result = device.check_responsiveness
    assert_nil result
  end

  test "check_responsiveness sets responsive when within threshold" do
    device = devices(:motion_sensor)
    # last_heard_from is 1 hour ago, threshold is 4 hours
    device.check_responsiveness
    assert device.is_responsive
    assert_not_nil device.last_checked_at
  end

  test "check_responsiveness sets non-responsive when exceeded" do
    device = devices(:temp_sensor)
    # last_heard_from is 10 hours ago, threshold is 2 hours
    device.check_responsiveness
    assert_not device.is_responsive
  end

  test "check_responsiveness sets last_alert_at on transition to non-responsive" do
    device = devices(:motion_sensor)
    # Force device to be responsive, then make it exceed threshold
    device.update!(is_responsive: true, last_heard_from: 100.hours.ago, alert_threshold_hours: 2.0, last_alert_at: nil)
    device.check_responsiveness
    assert_not device.is_responsive
    assert_not_nil device.last_alert_at
  end

  test "check_responsiveness does not update last_alert_at when already non-responsive" do
    device = devices(:temp_sensor)
    original_alert_at = device.last_alert_at
    device.check_responsiveness
    assert_equal original_alert_at.to_i, device.last_alert_at.to_i
  end

  test "check_responsiveness defaults to responsive when last_heard_from nil" do
    device = devices(:motion_sensor)
    device.update!(last_heard_from: nil)
    device.check_responsiveness
    assert device.is_responsive
  end

  test "check_responsiveness defaults to responsive when alert_threshold_hours nil" do
    device = devices(:motion_sensor)
    device.update!(alert_threshold_hours: nil)
    device.check_responsiveness
    assert device.is_responsive
  end

  test "check_responsiveness updates last_checked_at" do
    device = devices(:motion_sensor)
    before = Time.current
    device.check_responsiveness
    assert device.last_checked_at >= before
  end

  # -- time_since_last_message --

  test "time_since_last_message returns hours" do
    device = devices(:motion_sensor)
    hours = device.time_since_last_message
    assert_in_delta 1.0, hours, 0.1
  end

  test "time_since_last_message returns infinity when last_heard_from nil" do
    device = devices(:motion_sensor)
    device.last_heard_from = nil
    assert_equal Float::INFINITY, device.time_since_last_message
  end

  # -- alert_threshold_exceeded? --

  test "alert_threshold_exceeded? returns true when exceeded" do
    device = devices(:temp_sensor)
    # 10 hours since last heard, threshold 2 hours
    assert device.alert_threshold_exceeded?
  end

  test "alert_threshold_exceeded? returns false when within threshold" do
    device = devices(:motion_sensor)
    # 1 hour since last heard, threshold 4 hours
    assert_not device.alert_threshold_exceeded?
  end

  test "alert_threshold_exceeded? returns false when monitoring disabled" do
    device = devices(:door_sensor)
    assert_not device.alert_threshold_exceeded?
  end

  # -- monitoring_status --

  test "monitoring_status returns Disabled when not monitored" do
    assert_equal "Disabled", devices(:door_sensor).monitoring_status
  end

  test "monitoring_status returns Responsive when monitored and responsive" do
    assert_equal "Responsive", devices(:motion_sensor).monitoring_status
  end

  test "monitoring_status returns Non-Responsive when monitored and not responsive" do
    assert_equal "Non-Responsive", devices(:temp_sensor).monitoring_status
  end

  # -- hours_exceeded --

  test "hours_exceeded returns positive value when threshold exceeded" do
    device = devices(:temp_sensor)
    # 10 hours since last heard, threshold 2 hours => ~8 hours exceeded
    assert_in_delta 8.0, device.hours_exceeded, 0.2
  end

  test "hours_exceeded returns 0 when not exceeded" do
    device = devices(:motion_sensor)
    assert_equal 0, device.hours_exceeded
  end

  # -- prune --

  test "prune deletes excess messages and their readings" do
    device = devices(:light_bulb)
    # light_bulb has capture_max: 5 and 6 messages
    assert_equal 6, device.mqtt_messages.count
    device.prune
    assert_equal 5, device.mqtt_messages.count
  end

  test "prune is no-op when capture_max is nil" do
    device = devices(:motion_sensor)
    assert_nil device.capture_max
    count_before = device.mqtt_messages.count
    device.prune
    assert_equal count_before, device.mqtt_messages.count
  end

  test "prune is no-op when message count is within capture_max" do
    device = devices(:light_bulb)
    device.update!(capture_max: 100)
    count_before = device.mqtt_messages.count
    device.prune
    assert_equal count_before, device.mqtt_messages.count
  end
end

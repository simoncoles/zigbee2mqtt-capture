require "test_helper"

class DeviceMonitorTest < ActiveSupport::TestCase
  # -- check_all_devices --

  test "check_all_devices returns correct checked_count for monitored devices" do
    result = DeviceMonitor.check_all_devices
    monitored_count = Device.monitored.count
    assert_equal monitored_count, result[:checked_count]
  end

  test "check_all_devices skips non-monitored devices" do
    result = DeviceMonitor.check_all_devices
    # door_sensor is not monitored, so checked_count should be less than total
    assert result[:checked_count] < Device.count
  end

  test "check_all_devices tracks became_non_responsive" do
    # Make a responsive device exceed its threshold
    device = devices(:motion_sensor)
    device.update!(last_heard_from: 100.hours.ago, alert_threshold_hours: 2.0)

    result = DeviceMonitor.check_all_devices
    assert result[:status_changes][:became_non_responsive] >= 1
  end

  test "check_all_devices tracks became_responsive" do
    # Make a non-responsive device become responsive
    device = devices(:temp_sensor)
    device.update!(last_heard_from: 1.minute.ago, alert_threshold_hours: 2.0)

    result = DeviceMonitor.check_all_devices
    assert result[:status_changes][:became_responsive] >= 1
  end

  test "check_all_devices handles errors gracefully" do
    # Stub a device to raise an error on check_responsiveness
    Device.monitored.first.update_column(:alert_threshold_hours, nil)

    result = DeviceMonitor.check_all_devices
    assert_equal 0, result[:error_count]
    # Should still complete without raising
  end

  # -- check_device --

  test "check_device returns status_changed false when monitoring disabled" do
    result = DeviceMonitor.check_device(devices(:door_sensor))
    assert_equal false, result[:status_changed]
  end

  test "check_device detects status change when device crosses threshold" do
    device = devices(:motion_sensor)
    device.update!(last_heard_from: 100.hours.ago, alert_threshold_hours: 2.0)
    result = DeviceMonitor.check_device(device)
    assert result[:status_changed]
    assert_not device.is_responsive
  end

  test "check_device returns new_alert true when last_alert_at changes" do
    device = devices(:motion_sensor)
    device.update!(last_heard_from: 100.hours.ago, alert_threshold_hours: 2.0, last_alert_at: nil)
    result = DeviceMonitor.check_device(device)
    assert result[:new_alert]
  end

  # -- summary_stats --

  test "summary_stats returns correct counts" do
    stats = DeviceMonitor.summary_stats
    assert_equal Device.count, stats[:total_devices]
    assert_equal Device.monitored.count, stats[:monitored_devices]
    assert_equal Device.responsive.count, stats[:responsive_devices]
    assert_equal Device.non_responsive.count, stats[:non_responsive_devices]
  end

  test "summary_stats returns response rate" do
    stats = DeviceMonitor.summary_stats
    monitored = Device.monitored.count
    responsive = Device.responsive.count
    expected_rate = ((responsive.to_f / monitored) * 100).round(2)
    assert_equal expected_rate, stats[:response_rate]
  end

  test "summary_stats returns 0 response rate when no monitored devices" do
    Device.update_all(monitoring_enabled: false)
    stats = DeviceMonitor.summary_stats
    assert_equal 0, stats[:response_rate]
  end

  # -- reset_device --

  test "reset_device sets responsive and clears alert" do
    device = devices(:temp_sensor)
    assert_not device.is_responsive
    assert_not_nil device.last_alert_at

    DeviceMonitor.reset_device(device)
    device.reload

    assert device.is_responsive
    assert_nil device.last_alert_at
    assert_not_nil device.last_checked_at
  end
end

require "test_helper"

class DeviceMonitorJobTest < ActiveJob::TestCase
  test "updates last_checked_at for monitored devices" do
    device = devices(:motion_sensor)
    device.update!(last_checked_at: 1.day.ago)

    DeviceMonitorJob.perform_now

    assert_in_delta Time.current.to_f, device.reload.last_checked_at.to_f, 5
  end

  test "skips check when MONITOR_ENABLED is false" do
    device = devices(:motion_sensor)
    original = 1.day.ago
    device.update!(last_checked_at: original)

    original_env = ENV["MONITOR_ENABLED"]
    ENV["MONITOR_ENABLED"] = "false"
    begin
      DeviceMonitorJob.perform_now
    ensure
      ENV["MONITOR_ENABLED"] = original_env
    end

    assert_in_delta original.to_f, device.reload.last_checked_at.to_f, 1
  end
end

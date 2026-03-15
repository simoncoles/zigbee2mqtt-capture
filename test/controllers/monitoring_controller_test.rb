require "test_helper"

class MonitoringControllerTest < ActionDispatch::IntegrationTest
  test "GET /monitoring returns 200" do
    get monitoring_index_path
    assert_response :success
  end

  test "GET /monitoring/device/:id returns 200" do
    device = devices(:motion_sensor)
    get device_monitoring_path(device)
    assert_response :success
  end

  test "POST /monitoring/device/:id/toggle toggles monitoring and redirects" do
    device = devices(:motion_sensor)
    assert device.monitoring_enabled?

    post toggle_monitoring_path(device), params: { enabled: "false" }
    assert_response :redirect

    device.reload
    assert_not device.monitoring_enabled?
  end

  test "POST /monitoring/device/:id/reset resets alert and redirects" do
    device = devices(:temp_sensor)
    assert_not device.is_responsive

    post reset_monitoring_path(device)
    assert_response :redirect

    device.reload
    assert device.is_responsive
    assert_nil device.last_alert_at
  end

  test "POST /monitoring/device/:id/recalculate updates threshold and redirects" do
    device = devices(:motion_sensor)
    old_threshold = device.alert_threshold_hours

    post recalculate_threshold_monitoring_path(device)
    assert_response :redirect

    device.reload
    assert_not_nil device.alert_threshold_hours
  end
end

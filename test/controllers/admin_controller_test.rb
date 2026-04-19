require "test_helper"

class AdminControllerTest < ActionDispatch::IntegrationTest
  test "GET /admin returns 200 and shows table counts" do
    get admin_path
    assert_response :success
    assert_match "Admin", response.body
    assert_match "Device", response.body
    assert_match "MqttMessage", response.body
    assert_match "Reading", response.body
    assert_match "MqttTopic", response.body
    assert_match "RawMqttMessage", response.body
  end

  test "GET /admin/confirm_destroy returns 200" do
    get confirm_destroy_admin_path
    assert_response :success
    assert_match "Confirm Data Deletion", response.body
    assert_match "DELETE ALL DATA", response.body
  end

  test "POST /admin/destroy_all with wrong phrase deletes nothing" do
    devices_before = Device.count
    messages_before = MqttMessage.count
    readings_before = Reading.count
    assert devices_before > 0

    post destroy_all_admin_path, params: { confirmation: "delete all data" }
    assert_redirected_to confirm_destroy_admin_path
    assert_match(/did not match/i, flash[:alert])

    assert_equal devices_before, Device.count
    assert_equal messages_before, MqttMessage.count
    assert_equal readings_before, Reading.count
  end

  test "POST /admin/destroy_all with empty phrase deletes nothing" do
    devices_before = Device.count
    post destroy_all_admin_path, params: {}
    assert_redirected_to confirm_destroy_admin_path
    assert_equal devices_before, Device.count
  end

  test "POST /admin/destroy_all with correct phrase empties all tables" do
    assert Device.count > 0
    assert MqttMessage.count > 0
    assert Reading.count > 0
    assert MqttTopic.count > 0
    assert RawMqttMessage.count > 0

    post destroy_all_admin_path, params: { confirmation: "DELETE ALL DATA" }
    assert_redirected_to admin_path
    assert_match(/Deleted/, flash[:notice])

    assert_equal 0, Device.count
    assert_equal 0, MqttMessage.count
    assert_equal 0, Reading.count
    assert_equal 0, MqttTopic.count
    assert_equal 0, RawMqttMessage.count
  end

  test "POST /admin/destroy_all tolerates whitespace around the phrase" do
    post destroy_all_admin_path, params: { confirmation: "  DELETE ALL DATA  " }
    assert_redirected_to admin_path
    assert_equal 0, Device.count
  end
end

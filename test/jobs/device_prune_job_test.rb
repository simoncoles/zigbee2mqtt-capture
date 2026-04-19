require "test_helper"

class DevicePruneJobTest < ActiveJob::TestCase
  test "prunes devices with capture_max set and their readings" do
    device = devices(:light_bulb)
    # fixture: capture_max: 5, 6 mqtt_messages
    assert_equal 6, device.mqtt_messages.count

    DevicePruneJob.perform_now

    assert_equal 5, device.mqtt_messages.reload.count
  end

  test "skips devices where capture_max is nil" do
    motion = devices(:motion_sensor)
    assert_nil motion.capture_max
    count_before = motion.mqtt_messages.count

    DevicePruneJob.perform_now

    assert_equal count_before, motion.mqtt_messages.reload.count
  end

  test "deletes readings attached to pruned messages" do
    device = devices(:light_bulb)
    # Add a reading on the oldest message so we can confirm it disappears.
    oldest = device.mqtt_messages.order(:created_at).first
    Reading.create!(key: "linkquality", value: "130",
                    mqtt_message: oldest, device: device)
    reading_id = Reading.where(mqtt_message_id: oldest.id).pluck(:id)
    assert reading_id.any?

    DevicePruneJob.perform_now

    assert_equal 0, Reading.where(id: reading_id).count
    assert_equal 0, MqttMessage.where(id: oldest.id).count
  end
end

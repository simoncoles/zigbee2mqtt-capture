require "test_helper"

class MqttMessagePruneJobTest < ActiveJob::TestCase
  setup do
    @device = devices(:motion_sensor)
    @original_batch = MqttMessagePruneJob::BATCH_SIZE
  end

  teardown do
    ENV.delete("PRUNE_HOURS")
    silence_warnings { MqttMessagePruneJob.const_set(:BATCH_SIZE, @original_batch) }
  end

  test "deletes messages older than PRUNE_HOURS and their readings" do
    old_message = MqttMessage.create!(
      topic: "zigbee2mqtt/X", content: "{}",
      friendly_name: @device.friendly_name, device: @device,
      created_at: 10.hours.ago
    )
    old_reading = Reading.create!(key: "battery", value: "1",
                                  mqtt_message: old_message, device: @device)
    fresh_message = MqttMessage.create!(
      topic: "zigbee2mqtt/Y", content: "{}",
      friendly_name: @device.friendly_name, device: @device,
      created_at: 30.minutes.ago
    )

    ENV["PRUNE_HOURS"] = "2"
    MqttMessagePruneJob.perform_now

    assert_nil MqttMessage.find_by(id: old_message.id)
    assert_nil Reading.find_by(id: old_reading.id)
    assert MqttMessage.exists?(fresh_message.id)
  end

  test "chunks deletes so a single run spans multiple batches" do
    silence_warnings { MqttMessagePruneJob.const_set(:BATCH_SIZE, 2) }
    created_ids = Array.new(5) do |i|
      MqttMessage.create!(
        topic: "zigbee2mqtt/X#{i}", content: "{}",
        friendly_name: @device.friendly_name, device: @device,
        created_at: 10.hours.ago - i.minutes
      ).id
    end

    ENV["PRUNE_HOURS"] = "2"
    MqttMessagePruneJob.perform_now

    assert_equal 0, MqttMessage.where(id: created_ids).count
  end
end

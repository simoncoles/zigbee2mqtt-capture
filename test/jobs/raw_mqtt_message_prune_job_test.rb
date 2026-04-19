require "test_helper"

class RawMqttMessagePruneJobTest < ActiveJob::TestCase
  setup do
    @topic = mqtt_topics(:home_assistant_status)
    @original_batch = RawMqttMessagePruneJob::BATCH_SIZE
  end

  teardown do
    ENV.delete("PRUNE_HOURS")
    silence_warnings { RawMqttMessagePruneJob.const_set(:BATCH_SIZE, @original_batch) }
  end

  test "deletes raw messages older than PRUNE_HOURS and leaves fresh ones alone" do
    old = RawMqttMessage.create!(
      mqtt_topic: @topic, topic: @topic.name, payload: "old",
      created_at: 10.hours.ago
    )
    fresh = RawMqttMessage.create!(
      mqtt_topic: @topic, topic: @topic.name, payload: "fresh",
      created_at: 30.minutes.ago
    )

    ENV["PRUNE_HOURS"] = "2"
    RawMqttMessagePruneJob.perform_now

    assert_nil RawMqttMessage.find_by(id: old.id)
    assert RawMqttMessage.exists?(fresh.id)
  end

  test "deletes across multiple batches in a single run" do
    silence_warnings { RawMqttMessagePruneJob.const_set(:BATCH_SIZE, 2) }
    cutoff = 10.hours.ago
    created_ids = Array.new(5) do |i|
      RawMqttMessage.create!(
        mqtt_topic: @topic, topic: @topic.name, payload: "p#{i}",
        created_at: cutoff - i.minutes
      ).id
    end

    ENV["PRUNE_HOURS"] = "2"
    RawMqttMessagePruneJob.perform_now

    assert_equal 0, RawMqttMessage.where(id: created_ids).count
  end
end

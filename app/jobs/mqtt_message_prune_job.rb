class MqttMessagePruneJob < ApplicationJob
  queue_as :default
  BATCH_SIZE = 10_000

  def perform
    cutoff = ENV.fetch("PRUNE_HOURS", 48).to_i.hours.ago
    loop do
      doomed_ids = MqttMessage.where("created_at < ?", cutoff)
                              .limit(BATCH_SIZE).pluck(:id)
      break if doomed_ids.empty?
      Reading.where(mqtt_message_id: doomed_ids).delete_all
      MqttMessage.where(id: doomed_ids).delete_all
    end
  end
end

class RawMqttMessagePruneJob < ApplicationJob
  queue_as :default
  BATCH_SIZE = 10_000

  def perform
    cutoff = ENV.fetch("PRUNE_HOURS", 48).to_i.hours.ago
    loop do
      deleted = RawMqttMessage.where("created_at < ?", cutoff)
                              .limit(BATCH_SIZE).delete_all
      break if deleted.zero?
    end
  end
end

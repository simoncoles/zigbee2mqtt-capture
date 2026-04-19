# == Schema Information
#
# Table name: mqtt_topics
#
#  id            :integer          not null, primary key
#  first_seen_at :datetime         not null
#  handled       :boolean          default(FALSE), not null
#  last_seen_at  :datetime         not null
#  message_count :integer          default(0), not null
#  name          :string           not null
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#
# Indexes
#
#  index_mqtt_topics_on_handled        (handled)
#  index_mqtt_topics_on_last_seen_at   (last_seen_at)
#  index_mqtt_topics_on_message_count  (message_count)
#  index_mqtt_topics_on_name           (name) UNIQUE
#
class MqttTopic < ApplicationRecord
  has_many :raw_mqtt_messages, dependent: :delete_all

  scope :search, ->(query) {
    return all if query.blank?
    where("name LIKE :q", q: "%#{query}%")
  }

  scope :handled,   -> { where(handled: true) }
  scope :unhandled, -> { where(handled: false) }

  # Single source of truth for "is this topic already processed by existing code?".
  # Today the zigbee ingest path stores first-level-prefix "zigbee*" topics in
  # mqtt_messages. Widen or replace this rule here if the definition ever changes.
  def self.topic_handled?(topic_string)
    prefix = topic_string.to_s.split("/", 2).first
    prefix.to_s.start_with?("zigbee")
  end

  # Upsert by name, bump counters. Called on every incoming MQTT packet.
  # If topic names grow unbounded (e.g. UUIDs in topic strings), add a pruner
  # for rows where last_seen_at is older than some horizon.
  def self.record_seen!(topic_string, now: Time.current)
    topic = find_or_create_by!(name: topic_string) do |t|
      t.handled       = topic_handled?(topic_string)
      t.first_seen_at = now
      t.last_seen_at  = now
      t.message_count = 0
    end
    where(id: topic.id).update_all(last_seen_at: now)
    increment_counter(:message_count, topic.id)
    topic
  rescue ActiveRecord::RecordNotUnique
    retry
  end
end

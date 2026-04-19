# == Schema Information
#
# Table name: raw_mqtt_messages
#
#  id            :integer          not null, primary key
#  payload       :text
#  qos           :integer          default(0), not null
#  retained      :boolean          default(FALSE), not null
#  topic         :string           not null
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  mqtt_topic_id :integer          not null
#
# Indexes
#
#  index_raw_mqtt_messages_on_created_at                    (created_at)
#  index_raw_mqtt_messages_on_mqtt_topic_id                 (mqtt_topic_id)
#  index_raw_mqtt_messages_on_mqtt_topic_id_and_created_at  (mqtt_topic_id,created_at DESC)
#  index_raw_mqtt_messages_on_topic                         (topic)
#
# Foreign Keys
#
#  mqtt_topic_id  (mqtt_topic_id => mqtt_topics.id)
#
class RawMqttMessage < ApplicationRecord
  belongs_to :mqtt_topic

  scope :search, ->(query) {
    return all if query.blank?
    where("topic LIKE :q OR payload LIKE :q", q: "%#{query}%")
  }

  # To test run with `rails runner RawMqttMessage.prune_old`
  def self.prune_old
    while true
      prune_hours = ENV.fetch("PRUNE_HOURS", 48).to_i
      RawMqttMessage.where("created_at < ?", prune_hours.hours.ago).delete_all
      sleep 3600
    end
  end
end

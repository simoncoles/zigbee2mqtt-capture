# == Schema Information
#
# Table name: readings
#
#  id              :integer          not null, primary key
#  key             :string
#  value           :string
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  device_id       :integer          not null
#  mqtt_message_id :integer          not null
#
# Indexes
#
#  index_readings_on_created_at                (created_at)
#  index_readings_on_device_id                 (device_id)
#  index_readings_on_device_id_and_created_at  (device_id,created_at DESC)
#  index_readings_on_device_key_created        (device_id,key,created_at DESC)
#  index_readings_on_key                       (key)
#  index_readings_on_mqtt_message_id           (mqtt_message_id)
#  index_readings_on_value                     (value)
#
# Foreign Keys
#
#  device_id        (device_id => devices.id)
#  mqtt_message_id  (mqtt_message_id => mqtt_messages.id)
#
class Reading < ApplicationRecord
  belongs_to :mqtt_message
  belongs_to :device

  scope :search, ->(query) {
    return all if query.blank?
    left_joins(:device).where(
      "readings.key LIKE :q OR readings.value LIKE :q OR devices.friendly_name LIKE :q", q: "%#{query}%"
    )
  }
end

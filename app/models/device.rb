# == Schema Information
#
# Table name: devices
#
#  id                :integer          not null, primary key
#  capture_max       :integer
#  device_type       :string
#  friendly_name     :string
#  ieee_addr         :string
#  last_heard_from   :datetime
#  manufacturer_name :string
#  model             :string
#  network_address   :integer
#  power_source      :string
#  zcl_version       :integer
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#
class Device < ApplicationRecord
  has_many :mqtt_messages

  # Prune messages inexcess of capture_max
  def prune
    # If capture_max is set for this device, prune messages in excess of capture_max
    unless capture_max.nil?
      # Find the IDs of the messages to keep
      kept_messages = mqtt_messages.order(created_at: :desc).limit(capture_max).pluck(:id)

      # Delete messages not included in kept_messages
      mqtt_messages.each do |message|
        unless kept_messages.include?(message.id)
          message.destroy
        end
      end
    end
  end
end

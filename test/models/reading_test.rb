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
#  index_readings_on_device_id        (device_id)
#  index_readings_on_mqtt_message_id  (mqtt_message_id)
#
# Foreign Keys
#
#  device_id        (device_id => devices.id)
#  mqtt_message_id  (mqtt_message_id => mqtt_messages.id)
#
require "test_helper"

class ReadingTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end

# == Schema Information
#
# Table name: mqtt_messages
#
#  id             :integer          not null, primary key
#  content        :text
#  formatted_json :text
#  friendly_name  :string
#  model          :string
#  topic          :string
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  device_id      :bigint
#
# Indexes
#
#  index_mqtt_messages_on_device_id      (device_id)
#  index_mqtt_messages_on_friendly_name  (friendly_name)
#  index_mqtt_messages_on_topic          (topic)
#
require "test_helper"

class MqttMessageTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end

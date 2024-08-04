# == Schema Information
#
# Table name: mqtt_messages
#
#  id         :bigint           not null, primary key
#  content    :text
#  topic      :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_mqtt_messages_on_topic  (topic)
#
class MqttMessage < ApplicationRecord

  def self.connect
    client = MQTT::Client.connect(ENV['MQTT_URI'])
    client.subscribe('zigbee2mqtt/+')
    client.get do |topic, message|
      puts topic, message
      MqttMessage.create(topic: topic, content: message)
    end
  end


end

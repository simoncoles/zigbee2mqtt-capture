# == Schema Information
#
# Table name: mqtt_messages
#
#  id             :bigint           not null, primary key
#  content        :text
#  formatted_json :text
#  friendly_name  :string
#  topic          :string
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#
# Indexes
#
#  index_mqtt_messages_on_topic  (topic)
#
class MqttMessage < ApplicationRecord

  # Run with `rails runner MqttMessage.connect`
  def self.connect
    client = MQTT::Client.connect(ENV['MQTT_URI'])
    client.subscribe('zigbee2mqtt/+')
    client.get do |topic, message|
      puts topic, message
      parsed_json = JSON.parse(message)
      friendlyName = parsed_json['device']['friendlyName']
      formatted_json = JSON.generate(parsed_json).lines.map(&:strip).join("\n")
      MqttMessage.create(topic: topic, content: message, friendly_name: friendlyName, formatted_json: formatted_json)
    end
  end


end

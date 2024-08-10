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
class MqttMessage < ApplicationRecord

  belongs_to :device

  # To test run with `rails runner MqttMessage.listen`
  def self.listen
    client = MQTT::Client.connect(ENV['MQTT_URL'])
    client.subscribe('zigbee2mqtt/+', 'zigbee2mqtt/+/availability')
    client.get do |topic, message|
      puts topic, message
      parsed_json = JSON.parse(message)

      # Get device information
      device_info = parsed_json['device']
      friendlyName = device_info['friendlyName']
      model = device_info['model']
      ieeeAddr = device_info['ieeeAddr']
      manufacturer_name = device_info['manufacturerName']
      network_address = device_info['networkAddress']
      power_source = device_info['powerSource']
      device_type = device_info['type']
      zcl_version = device_info['zclVersion']


      # Find or create the device
      device = Device.find_or_create_by(friendly_name: friendlyName)
      device.update(
        ieee_addr: ieeeAddr,
        manufacturer_name: manufacturer_name,
        model: model,
        network_address: network_address,
        power_source: power_source,
        device_type: device_type,
        zcl_version: zcl_version,
        last_heard_from: Time.now,
      )


      friendlyName = parsed_json['device']['friendlyName']
      model = parsed_json['device']['model']
      formatted_json = JSON.pretty_generate(parsed_json)
      MqttMessage.create(topic: topic,
                         content: message,
                         friendly_name: friendlyName,
                         model: model,
                         formatted_json: formatted_json,
                         device_id: device.id,
                         )

      # Prune old messages for this device
      device.prune
    end
  end

  def self.prune_old
    # Prune old messages once a minute
    prune_hours = ENV.fetch('PRUNE_HOURS', 48).to_i
    MqttMessage.where('created_at < ?', prune_hours.hours.ago).delete_all
    sleep 60
  end



end

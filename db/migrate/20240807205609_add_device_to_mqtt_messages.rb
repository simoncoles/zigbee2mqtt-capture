class AddDeviceToMqttMessages < ActiveRecord::Migration[7.2]
  def change
    add_reference :mqtt_messages, :device
  end
end

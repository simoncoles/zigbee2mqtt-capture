class AddIndexToMqttMessagesFriendlyName < ActiveRecord::Migration[7.2]
  def change
    add_index :mqtt_messages, :friendly_name
  end
end

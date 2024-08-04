class AddFormattedJsonToMqttMessages < ActiveRecord::Migration[7.2]
  def change
    add_column :mqtt_messages, :formatted_json, :text
  end
end

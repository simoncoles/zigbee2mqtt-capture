class RemoveFormattedJsonFromMqttMessages < ActiveRecord::Migration[8.1]
  def change
    remove_column :mqtt_messages, :formatted_json, :text
  end
end

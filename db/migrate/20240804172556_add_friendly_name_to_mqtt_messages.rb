class AddFriendlyNameToMqttMessages < ActiveRecord::Migration[7.2]
  def change
    add_column :mqtt_messages, :friendly_name, :string
  end
end

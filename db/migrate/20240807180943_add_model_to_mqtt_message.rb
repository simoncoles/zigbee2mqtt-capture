class AddModelToMqttMessage < ActiveRecord::Migration[7.2]
  def change
    add_column :mqtt_messages, :model, :string
  end
end

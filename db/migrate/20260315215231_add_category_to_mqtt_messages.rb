class AddCategoryToMqttMessages < ActiveRecord::Migration[8.1]
  def change
    add_column :mqtt_messages, :category, :string, default: "device", null: false
    add_index :mqtt_messages, :category
  end
end

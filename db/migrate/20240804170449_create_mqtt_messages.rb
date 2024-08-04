class CreateMqttMessages < ActiveRecord::Migration[7.2]
  def change
    create_table :mqtt_messages do |t|
      t.string :topic
      t.text :content

      t.timestamps
    end
    add_index :mqtt_messages, :topic
  end
end

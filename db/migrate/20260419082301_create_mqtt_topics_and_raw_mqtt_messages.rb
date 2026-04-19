class CreateMqttTopicsAndRawMqttMessages < ActiveRecord::Migration[8.1]
  def change
    create_table :mqtt_topics do |t|
      t.string   :name,          null: false
      t.boolean  :handled,       null: false, default: false
      t.integer  :message_count, null: false, default: 0
      t.datetime :first_seen_at, null: false
      t.datetime :last_seen_at,  null: false
      t.timestamps
    end
    add_index :mqtt_topics, :name, unique: true
    add_index :mqtt_topics, :handled
    add_index :mqtt_topics, :last_seen_at
    add_index :mqtt_topics, :message_count

    create_table :raw_mqtt_messages do |t|
      t.references :mqtt_topic, null: false, foreign_key: true
      t.string  :topic,    null: false
      t.text    :payload
      t.boolean :retained, null: false, default: false
      t.integer :qos,      null: false, default: 0
      t.timestamps
    end
    add_index :raw_mqtt_messages, :topic
    add_index :raw_mqtt_messages, :created_at
    add_index :raw_mqtt_messages, [ :mqtt_topic_id, :created_at ], order: { created_at: :desc }
  end
end

class AddTrigramIndexesToMqttMessages < ActiveRecord::Migration[8.1]
  disable_ddl_transaction!

  def change
    enable_extension "pg_trgm"

    add_index :mqtt_messages, :topic,
      using: :gin, opclass: :gin_trgm_ops,
      name: "index_mqtt_messages_on_topic_trgm",
      algorithm: :concurrently
    add_index :mqtt_messages, :friendly_name,
      using: :gin, opclass: :gin_trgm_ops,
      name: "index_mqtt_messages_on_friendly_name_trgm",
      algorithm: :concurrently
    add_index :mqtt_messages, :content,
      using: :gin, opclass: :gin_trgm_ops,
      name: "index_mqtt_messages_on_content_trgm",
      algorithm: :concurrently
  end
end

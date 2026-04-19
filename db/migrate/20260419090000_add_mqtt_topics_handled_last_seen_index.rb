class AddMqttTopicsHandledLastSeenIndex < ActiveRecord::Migration[8.1]
  def change
    add_index :mqtt_topics, [ :handled, :last_seen_at ],
              order: { last_seen_at: :desc },
              name: "index_mqtt_topics_on_handled_and_last_seen_at"
    remove_index :mqtt_topics, :handled, name: "index_mqtt_topics_on_handled"
  end
end

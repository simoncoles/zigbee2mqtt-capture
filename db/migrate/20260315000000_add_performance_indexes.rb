class AddPerformanceIndexes < ActiveRecord::Migration[8.0]
  def change
    add_index :readings, [ :device_id, :key, :created_at ], order: { created_at: :desc }, name: "index_readings_on_device_key_created"
    add_index :readings, :key, name: "index_readings_on_key"
    add_index :mqtt_messages, :created_at, name: "index_mqtt_messages_on_created_at"
    add_index :readings, :created_at, name: "index_readings_on_created_at"
    add_index :devices, :friendly_name, name: "index_devices_on_friendly_name"
    add_index :devices, [ :monitoring_enabled, :is_responsive, :last_heard_from ], order: { last_heard_from: :asc }, name: "index_devices_on_monitoring_responsive_last_heard"
  end
end

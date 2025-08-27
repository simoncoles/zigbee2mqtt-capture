class AddMonitoringDashboardIndexes < ActiveRecord::Migration[8.0]
  def change
    # Speeds up /monitoring list: WHERE monitoring_enabled AND is_responsive=false ORDER BY last_alert_at DESC
    add_index :devices,
              [:monitoring_enabled, :is_responsive, :last_alert_at],
              name: "index_devices_on_monitoring_and_responsive_and_last_alert_at",
              if_not_exists: true,
              order: {last_alert_at: :desc}

    # Speeds up per-device message queries: WHERE device_id = ? ORDER BY created_at DESC LIMIT N
    add_index :mqtt_messages,
              [:device_id, :created_at],
              name: "index_mqtt_messages_on_device_id_and_created_at",
              if_not_exists: true,
              order: {created_at: :desc}

    # Speeds up per-device reading queries with recent-first ordering
    add_index :readings,
              [:device_id, :created_at],
              name: "index_readings_on_device_id_and_created_at",
              if_not_exists: true,
              order: {created_at: :desc}
  end
end


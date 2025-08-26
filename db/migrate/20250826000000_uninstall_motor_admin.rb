class UninstallMotorAdmin < ActiveRecord::Migration[8.0]
  def up
    # Drop in dependency-safe order
    drop_table :motor_alert_locks, if_exists: true
    drop_table :motor_alerts, if_exists: true
    drop_table :motor_note_tag_tags, if_exists: true
    drop_table :motor_note_tags, if_exists: true
    drop_table :motor_notes, if_exists: true
    drop_table :motor_forms, if_exists: true
    drop_table :motor_taggable_tags, if_exists: true
    drop_table :motor_tags, if_exists: true
    drop_table :motor_notifications, if_exists: true
    drop_table :motor_reminders, if_exists: true
    drop_table :motor_api_configs, if_exists: true
    drop_table :motor_resources, if_exists: true
    drop_table :motor_configs, if_exists: true
    drop_table :motor_dashboards, if_exists: true
    drop_table :motor_queries, if_exists: true
    drop_table :motor_audits, if_exists: true
  end

  def down
    raise ActiveRecord::IrreversibleMigration, "Cannot automatically recreate Motor Admin tables"
  end
end


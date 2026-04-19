# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[8.1].define(version: 2026_04_19_150352) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"
  enable_extension "pg_trgm"

  create_table "devices", force: :cascade do |t|
    t.decimal "alert_threshold_hours", precision: 10, scale: 2
    t.integer "capture_max"
    t.datetime "created_at", null: false
    t.string "device_type"
    t.string "friendly_name"
    t.string "ieee_addr"
    t.boolean "is_responsive", default: true
    t.datetime "last_alert_at"
    t.datetime "last_checked_at"
    t.datetime "last_heard_from"
    t.string "manufacturer_name"
    t.string "model"
    t.boolean "monitoring_enabled", default: true
    t.integer "network_address"
    t.string "power_source"
    t.datetime "updated_at", null: false
    t.integer "zcl_version"
    t.index ["friendly_name"], name: "index_devices_on_friendly_name"
    t.index ["ieee_addr"], name: "index_devices_on_ieee_addr", unique: true
    t.index ["is_responsive"], name: "index_devices_on_is_responsive"
    t.index ["last_heard_from"], name: "index_devices_on_last_heard_from"
    t.index ["manufacturer_name"], name: "index_devices_on_manufacturer_name"
    t.index ["model"], name: "index_devices_on_model"
    t.index ["monitoring_enabled", "is_responsive", "last_alert_at"], name: "index_devices_on_monitoring_and_responsive_and_last_alert_at", order: { last_alert_at: :desc }
    t.index ["monitoring_enabled", "is_responsive", "last_heard_from"], name: "index_devices_on_monitoring_responsive_last_heard"
    t.index ["monitoring_enabled"], name: "index_devices_on_monitoring_enabled"
    t.index ["power_source"], name: "index_devices_on_power_source"
  end

  create_table "good_job_batches", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.integer "callback_priority"
    t.text "callback_queue_name"
    t.datetime "created_at", null: false
    t.text "description"
    t.datetime "discarded_at"
    t.datetime "enqueued_at"
    t.datetime "finished_at"
    t.datetime "jobs_finished_at"
    t.text "on_discard"
    t.text "on_finish"
    t.text "on_success"
    t.jsonb "serialized_properties"
    t.datetime "updated_at", null: false
  end

  create_table "good_job_executions", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "active_job_id", null: false
    t.datetime "created_at", null: false
    t.interval "duration"
    t.text "error"
    t.text "error_backtrace", array: true
    t.integer "error_event", limit: 2
    t.datetime "finished_at"
    t.text "job_class"
    t.uuid "process_id"
    t.text "queue_name"
    t.datetime "scheduled_at"
    t.jsonb "serialized_params"
    t.datetime "updated_at", null: false
    t.index ["active_job_id", "created_at"], name: "index_good_job_executions_on_active_job_id_and_created_at"
    t.index ["process_id", "created_at"], name: "index_good_job_executions_on_process_id_and_created_at"
  end

  create_table "good_job_processes", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.datetime "created_at", null: false
    t.integer "lock_type", limit: 2
    t.jsonb "state"
    t.datetime "updated_at", null: false
  end

  create_table "good_job_settings", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.datetime "created_at", null: false
    t.text "key"
    t.datetime "updated_at", null: false
    t.jsonb "value"
    t.index ["key"], name: "index_good_job_settings_on_key", unique: true
  end

  create_table "good_jobs", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "active_job_id"
    t.uuid "batch_callback_id"
    t.uuid "batch_id"
    t.text "concurrency_key"
    t.datetime "created_at", null: false
    t.datetime "cron_at"
    t.text "cron_key"
    t.text "error"
    t.integer "error_event", limit: 2
    t.integer "executions_count"
    t.datetime "finished_at"
    t.boolean "is_discrete"
    t.text "job_class"
    t.text "labels", array: true
    t.integer "lock_type", limit: 2
    t.datetime "locked_at"
    t.uuid "locked_by_id"
    t.datetime "performed_at"
    t.integer "priority"
    t.text "queue_name"
    t.uuid "retried_good_job_id"
    t.datetime "scheduled_at"
    t.jsonb "serialized_params"
    t.datetime "updated_at", null: false
    t.index ["active_job_id", "created_at"], name: "index_good_jobs_on_active_job_id_and_created_at"
    t.index ["batch_callback_id"], name: "index_good_jobs_on_batch_callback_id", where: "(batch_callback_id IS NOT NULL)"
    t.index ["batch_id"], name: "index_good_jobs_on_batch_id", where: "(batch_id IS NOT NULL)"
    t.index ["concurrency_key", "created_at"], name: "index_good_jobs_on_concurrency_key_and_created_at"
    t.index ["concurrency_key"], name: "index_good_jobs_on_concurrency_key_when_unfinished", where: "(finished_at IS NULL)"
    t.index ["cron_key", "created_at"], name: "index_good_jobs_on_cron_key_and_created_at_cond", where: "(cron_key IS NOT NULL)"
    t.index ["cron_key", "cron_at"], name: "index_good_jobs_on_cron_key_and_cron_at_cond", unique: true, where: "(cron_key IS NOT NULL)"
    t.index ["finished_at"], name: "index_good_jobs_jobs_on_finished_at_only", where: "(finished_at IS NOT NULL)"
    t.index ["job_class"], name: "index_good_jobs_on_job_class"
    t.index ["labels"], name: "index_good_jobs_on_labels", where: "(labels IS NOT NULL)", using: :gin
    t.index ["locked_by_id"], name: "index_good_jobs_on_locked_by_id", where: "(locked_by_id IS NOT NULL)"
    t.index ["priority", "created_at"], name: "index_good_job_jobs_for_candidate_lookup", where: "(finished_at IS NULL)"
    t.index ["priority", "created_at"], name: "index_good_jobs_jobs_on_priority_created_at_when_unfinished", order: { priority: "DESC NULLS LAST" }, where: "(finished_at IS NULL)"
    t.index ["priority", "scheduled_at", "id"], name: "index_good_jobs_for_candidate_dequeue_unlocked", where: "((finished_at IS NULL) AND (locked_by_id IS NULL))"
    t.index ["priority", "scheduled_at", "id"], name: "index_good_jobs_on_priority_scheduled_at_unfinished", where: "(finished_at IS NULL)"
    t.index ["priority", "scheduled_at"], name: "index_good_jobs_on_priority_scheduled_at_unfinished_unlocked", where: "((finished_at IS NULL) AND (locked_by_id IS NULL))"
    t.index ["queue_name", "scheduled_at", "id"], name: "index_good_jobs_on_queue_name_priority_scheduled_at_unfinished", where: "(finished_at IS NULL)"
    t.index ["queue_name", "scheduled_at"], name: "index_good_jobs_on_queue_name_and_scheduled_at", where: "(finished_at IS NULL)"
    t.index ["scheduled_at"], name: "index_good_jobs_on_scheduled_at", where: "(finished_at IS NULL)"
  end

  create_table "mqtt_messages", force: :cascade do |t|
    t.string "category", default: "device", null: false
    t.text "content"
    t.datetime "created_at", null: false
    t.bigint "device_id"
    t.string "friendly_name"
    t.string "model"
    t.string "topic"
    t.datetime "updated_at", null: false
    t.index ["category"], name: "index_mqtt_messages_on_category"
    t.index ["content"], name: "index_mqtt_messages_on_content_trgm", opclass: :gin_trgm_ops, using: :gin
    t.index ["created_at"], name: "index_mqtt_messages_on_created_at"
    t.index ["device_id", "created_at"], name: "index_mqtt_messages_on_device_id_and_created_at", order: { created_at: :desc }
    t.index ["device_id"], name: "index_mqtt_messages_on_device_id"
    t.index ["friendly_name"], name: "index_mqtt_messages_on_friendly_name"
    t.index ["friendly_name"], name: "index_mqtt_messages_on_friendly_name_trgm", opclass: :gin_trgm_ops, using: :gin
    t.index ["topic"], name: "index_mqtt_messages_on_topic"
    t.index ["topic"], name: "index_mqtt_messages_on_topic_trgm", opclass: :gin_trgm_ops, using: :gin
  end

  create_table "mqtt_topics", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "first_seen_at", null: false
    t.boolean "handled", default: false, null: false
    t.datetime "last_seen_at", null: false
    t.integer "message_count", default: 0, null: false
    t.string "name", null: false
    t.datetime "updated_at", null: false
    t.index ["handled", "last_seen_at"], name: "index_mqtt_topics_on_handled_and_last_seen_at", order: { last_seen_at: :desc }
    t.index ["last_seen_at"], name: "index_mqtt_topics_on_last_seen_at"
    t.index ["message_count"], name: "index_mqtt_topics_on_message_count"
    t.index ["name"], name: "index_mqtt_topics_on_name", unique: true
  end

  create_table "raw_mqtt_messages", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.integer "mqtt_topic_id", null: false
    t.text "payload"
    t.integer "qos", default: 0, null: false
    t.boolean "retained", default: false, null: false
    t.string "topic", null: false
    t.datetime "updated_at", null: false
    t.index ["created_at"], name: "index_raw_mqtt_messages_on_created_at"
    t.index ["mqtt_topic_id", "created_at"], name: "index_raw_mqtt_messages_on_mqtt_topic_id_and_created_at", order: { created_at: :desc }
    t.index ["mqtt_topic_id"], name: "index_raw_mqtt_messages_on_mqtt_topic_id"
    t.index ["topic"], name: "index_raw_mqtt_messages_on_topic"
  end

  create_table "readings", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.integer "device_id", null: false
    t.string "key"
    t.integer "mqtt_message_id", null: false
    t.datetime "updated_at", null: false
    t.string "value"
    t.index ["created_at"], name: "index_readings_on_created_at"
    t.index ["device_id", "created_at"], name: "index_readings_on_device_id_and_created_at", order: { created_at: :desc }
    t.index ["device_id", "key", "created_at"], name: "index_readings_on_device_key_created", order: { created_at: :desc }
    t.index ["device_id"], name: "index_readings_on_device_id"
    t.index ["key"], name: "index_readings_on_key"
    t.index ["mqtt_message_id"], name: "index_readings_on_mqtt_message_id"
    t.index ["value"], name: "index_readings_on_value"
  end

  add_foreign_key "raw_mqtt_messages", "mqtt_topics"
  add_foreign_key "readings", "devices"
  add_foreign_key "readings", "mqtt_messages"
end

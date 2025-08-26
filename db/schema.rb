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

ActiveRecord::Schema[8.0].define(version: 2025_08_26_000000) do
  create_table "devices", force: :cascade do |t|
    t.string "friendly_name"
    t.string "ieee_addr"
    t.string "manufacturer_name"
    t.string "model"
    t.integer "network_address"
    t.string "power_source"
    t.string "device_type"
    t.integer "zcl_version"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "capture_max"
    t.datetime "last_heard_from"
    t.index ["ieee_addr"], name: "index_devices_on_ieee_addr", unique: true
  end

  create_table "mqtt_messages", force: :cascade do |t|
    t.string "topic"
    t.text "content"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "friendly_name"
    t.text "formatted_json"
    t.string "model"
    t.bigint "device_id"
    t.index ["device_id"], name: "index_mqtt_messages_on_device_id"
    t.index ["friendly_name"], name: "index_mqtt_messages_on_friendly_name"
    t.index ["topic"], name: "index_mqtt_messages_on_topic"
  end

  create_table "readings", force: :cascade do |t|
    t.string "key"
    t.string "value"
    t.integer "mqtt_message_id", null: false
    t.integer "device_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["device_id"], name: "index_readings_on_device_id"
    t.index ["mqtt_message_id"], name: "index_readings_on_mqtt_message_id"
  end

  add_foreign_key "readings", "devices"
  add_foreign_key "readings", "mqtt_messages"
end

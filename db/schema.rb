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

ActiveRecord::Schema[7.2].define(version: 2024_08_07_211259) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

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
end

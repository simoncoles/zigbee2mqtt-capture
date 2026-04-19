# == Schema Information
#
# Table name: mqtt_messages
#
#  id             :integer          not null, primary key
#  category       :string           default("device"), not null
#  content        :text
#  formatted_json :text
#  friendly_name  :string
#  model          :string
#  topic          :string
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  device_id      :bigint
#
# Indexes
#
#  index_mqtt_messages_on_category                  (category)
#  index_mqtt_messages_on_created_at                (created_at)
#  index_mqtt_messages_on_device_id                 (device_id)
#  index_mqtt_messages_on_device_id_and_created_at  (device_id,created_at DESC)
#  index_mqtt_messages_on_friendly_name             (friendly_name)
#  index_mqtt_messages_on_topic                     (topic)
#
class MqttMessage < ApplicationRecord
  # formatted_json used to be a persisted pretty-printed copy of `content`,
  # roughly doubling row size across millions of rows. It is now derived on
  # read (see #formatted_json below). The column is scheduled to be dropped;
  # until the migration runs, ignore it so we don't SELECT the stale TEXT.
  self.ignored_columns = %w[formatted_json]

  belongs_to :device, optional: true
  has_many :readings, dependent: :destroy

  scope :search, ->(query) {
    return all if query.blank?
    where("topic LIKE :q OR friendly_name LIKE :q OR content LIKE :q", q: "%#{query}%")
  }

  CATEGORY_BRIDGE = "bridge"
  CATEGORY_AVAILABILITY = "availability"
  CATEGORY_SYSTEM = "system"
  CATEGORY_DEVICE = "device"
  CATEGORY_COMMAND = "command"

  scope :device_messages, -> { where(category: CATEGORY_DEVICE) }
  scope :non_device_messages, -> { where(category: [ CATEGORY_BRIDGE, CATEGORY_AVAILABILITY, CATEGORY_SYSTEM ]) }
  scope :command_messages, -> { where(category: CATEGORY_COMMAND) }

  def self.categorize_topic(topic)
    return CATEGORY_COMMAND if topic.end_with?("/set")

    parts = topic.split("/")
    source = parts[1] # e.g. "bridge", "device_name"

    return CATEGORY_BRIDGE if source == "bridge"
    return CATEGORY_AVAILABILITY if parts.last == "availability"

    CATEGORY_SYSTEM
  end

  # Capture every incoming packet into the broker-wide raw store. Runs before
  # the zigbee branch so we see all topics, and is guarded by the caller's
  # rescue so a failure here can never break zigbee ingest.
  def self.capture_raw_message(topic, payload, retained: false, qos: 0)
    mqtt_topic = MqttTopic.record_seen!(topic)
    RawMqttMessage.create!(
      mqtt_topic_id: mqtt_topic.id,
      topic: topic,
      payload: payload,
      retained: retained,
      qos: qos
    )
  end

  #  To test run with `rails runner MqttMessage.listen`
  def self.listen
    Rails.logger.info("Connecting to MQTT broker at: #{ENV['MQTT_URL']}")
    client = MQTT::Client.connect(ENV["MQTT_URL"])
    # MQTT wildcards can't prefix-match, so subscribe to everything and filter
    # for any first-level topic starting with "zigbee" (e.g. zigbee2mqtt,
    # zigbee-shed, zigbee-conservatory).
    client.subscribe("#")
    client.get_packet do |packet|
      topic    = packet.topic
      message  = packet.payload
      retained = packet.retain
      qos      = packet.qos

      begin
        capture_raw_message(topic, message, retained: retained, qos: qos)
      rescue => e
        Rails.logger.error("Raw MQTT capture failed for #{topic}: #{e.class}: #{e.message}")
      end

      prefix = topic.split("/", 2).first
      next unless prefix&.start_with?("zigbee")

      # Persist /set command messages so they are visible in the UI.
      # Zigbee2MQTT is independently subscribed to /set on the broker and will
      # handle the actual command — we only capture a record of it.
      if topic.end_with?("/set")
        Rails.logger.info("Captured /set command: #{topic} #{message}")

        topic_parts = topic.split("/")
        friendly_name = topic_parts[1]

        device = friendly_name.present? ? Device.find_by(friendly_name: friendly_name) : nil

        MqttMessage.create(
          topic: topic,
          content: message,
          friendly_name: friendly_name,
          device_id: device&.id,
          category: CATEGORY_COMMAND
        )

        next
      end

      Rails.logger.info("#{topic}, #{message}")

      parsed_json = begin
        JSON.parse(message)
      rescue JSON::ParserError => e
        Rails.logger.warn("Failed to parse JSON: #{e.message}")
        nil
      end

      #  Get device information
      device_info = parsed_json&.dig("device")

      unless device_info
        # Store non-device message
        topic_parts = topic.split("/")
        source_name = topic_parts[1] || topic
        category = categorize_topic(topic)

        MqttMessage.create(
          topic: topic,
          content: message,
          friendly_name: source_name,
          category: category
        )
        next
      end

      friendlyName = device_info["friendlyName"]
      model = device_info["model"]
      ieeeAddr = device_info["ieeeAddr"]
      manufacturer_name = device_info["manufacturerName"]
      network_address = device_info["networkAddress"]
      power_source = device_info["powerSource"]
      device_type = device_info["type"]
      zcl_version = device_info["zclVersion"]

      # Find or create the device
      device = Device.find_or_create_by(ieee_addr: ieeeAddr)
      device.update(
        friendly_name: friendlyName,
        manufacturer_name: manufacturer_name,
        model: model,
        network_address: network_address,
        power_source: power_source,
        device_type: device_type,
        zcl_version: zcl_version,
        last_heard_from: Time.now,
        is_responsive: true  # Reset responsive status when we hear from device
      )

      friendlyName = parsed_json["device"]["friendlyName"]
      model = parsed_json["device"]["model"]
      mqtt_message = MqttMessage.create(
        topic: topic,
        content: message,
        friendly_name: friendlyName,
        model: model,
        device_id: device.id,
        category: CATEGORY_DEVICE
      )

      # This is a collection of attributes that are interesting to us
      interesting_attributes = [ "voltage", "temperature", "humidity", "pressure", "illuminance",
                                "occupancy", "contact", "battery", "linkquality", "vibration",
                                "x_axis", "y_axis", "z_axis", "angle", "angle_x", "angle_y", "angle_z",
                                "angle_x_absolute", "angle_y_absolute", "angle_z_absolute" ]
      # Create readings in bulk
      now = Time.current
      reading_records = interesting_attributes.filter_map { |attr|
        next unless parsed_json.key?(attr) && parsed_json[attr].present?
        { key: attr, value: parsed_json[attr].to_s, mqtt_message_id: mqtt_message.id, device_id: device.id, created_at: now, updated_at: now }
      }
      Reading.insert_all(reading_records) if reading_records.any?

      # Prune old messages for this device
      device.prune
    end
  end

  #  To test run with `rails runner MqttMessage.prune_old`
  def self.prune_old
    # Continuously prune old messages every minute
    while true
      prune_hours = ENV.fetch("PRUNE_HOURS", 48).to_i
      MqttMessage.transaction do
        old_messages = MqttMessage.where("created_at < ?", prune_hours.hours.ago)
        Reading.where(mqtt_message_id: old_messages.select(:id)).delete_all
        old_messages.delete_all
      end
      # Do it again in an hour
      sleep 3600
    end
  end

  # Pretty-printed JSON derived from content. Falls back to raw content when
  # content is not valid JSON so the UI still has something to display.
  def formatted_json
    return nil if content.blank?
    JSON.pretty_generate(JSON.parse(content))
  rescue JSON::ParserError
    content
  end

  # Render formatted_json as a safe, multiline, monospaced block for admin views
  def formatted_json_pre
    return "" if formatted_json.blank?

    escaped = ERB::Util.html_escape(formatted_json)
    "<pre class=\"font-mono whitespace-pre-wrap text-sm p-3 bg-gray-50 rounded border\">#{escaped}</pre>".html_safe
  end
end

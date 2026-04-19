# == Schema Information
#
# Table name: devices
#
#  id                    :integer          not null, primary key
#  alert_threshold_hours :decimal(10, 2)
#  capture_max           :integer
#  device_type           :string
#  friendly_name         :string
#  ieee_addr             :string
#  is_responsive         :boolean          default(TRUE)
#  last_alert_at         :datetime
#  last_checked_at       :datetime
#  last_heard_from       :datetime
#  manufacturer_name     :string
#  model                 :string
#  monitoring_enabled    :boolean          default(TRUE)
#  network_address       :integer
#  power_source          :string
#  zcl_version           :integer
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#
# Indexes
#
#  index_devices_on_friendly_name                                (friendly_name)
#  index_devices_on_ieee_addr                                    (ieee_addr) UNIQUE
#  index_devices_on_is_responsive                                (is_responsive)
#  index_devices_on_last_heard_from                              (last_heard_from)
#  index_devices_on_manufacturer_name                            (manufacturer_name)
#  index_devices_on_model                                        (model)
#  index_devices_on_monitoring_and_responsive_and_last_alert_at  (monitoring_enabled,is_responsive,last_alert_at DESC)
#  index_devices_on_monitoring_enabled                           (monitoring_enabled)
#  index_devices_on_monitoring_responsive_last_heard             (monitoring_enabled,is_responsive,last_heard_from)
#  index_devices_on_power_source                                 (power_source)
#
class Device < ApplicationRecord
  has_many :mqtt_messages, dependent: :destroy
  has_many :readings, dependent: :destroy

  scope :search, ->(query) {
    return all if query.blank?
    where("friendly_name LIKE :q OR model LIKE :q OR manufacturer_name LIKE :q OR ieee_addr LIKE :q", q: "%#{query}%")
  }

  # Monitoring scopes
  scope :monitored, -> { where(monitoring_enabled: true) }
  scope :non_responsive, -> { where(is_responsive: false, monitoring_enabled: true) }
  scope :responsive, -> { where(is_responsive: true, monitoring_enabled: true) }

  # Calculate initial threshold based on last two messages
  def calculate_initial_threshold
    messages = mqtt_messages.order(created_at: :desc).limit(2).pluck(:created_at)

    if messages.count == 2
      interval_seconds = (messages[0] - messages[1]).abs
      interval_hours = interval_seconds / 3600.0

      # Set threshold to 2x the interval, with min 1 hour and max 168 hours (1 week)
      threshold = [ interval_hours * 2, 1.0 ].max
      [ threshold, 168.0 ].min
    else
      24.0 # Default to 24 hours
    end
  end

  # Check if device has exceeded its alert threshold
  def check_responsiveness
    return unless monitoring_enabled?

    was_responsive = is_responsive
    hours_since_last = time_since_last_message

    self.is_responsive = if last_heard_from.present? && alert_threshold_hours.present?
                           hours_since_last <= alert_threshold_hours
    else
                           true # Default to responsive if no data
    end

    self.last_checked_at = Time.current

    # Track when device becomes non-responsive
    if was_responsive && !is_responsive
      self.last_alert_at = Time.current
    end

    save
  end

  # Calculate hours since last message
  def time_since_last_message
    return Float::INFINITY unless last_heard_from.present?
    (Time.current - last_heard_from) / 3600.0
  end

  # Check if alert threshold exceeded
  def alert_threshold_exceeded?
    return false unless monitoring_enabled? && alert_threshold_hours.present?
    time_since_last_message > alert_threshold_hours
  end

  # Human readable status
  def monitoring_status
    return "Disabled" unless monitoring_enabled?
    is_responsive? ? "Responsive" : "Non-Responsive"
  end

  # Time exceeded in hours (for non-responsive devices)
  def hours_exceeded
    return 0 unless alert_threshold_exceeded?
    time_since_last_message - alert_threshold_hours
  end

  # Prune messages in excess of capture_max
  def prune
    return if capture_max.nil?

    kept_message_ids = mqtt_messages.order(created_at: :desc).limit(capture_max).pluck(:id)
    messages_to_delete = mqtt_messages.where.not(id: kept_message_ids)

    # Delete associated readings first, then messages
    Reading.where(mqtt_message_id: messages_to_delete.select(:id)).delete_all
    messages_to_delete.delete_all
  end
end

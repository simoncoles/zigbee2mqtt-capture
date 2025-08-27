# == Schema Information
#
# Table name: devices
#
#  id                :integer          not null, primary key
#  capture_max       :integer
#  device_type       :string
#  friendly_name     :string
#  ieee_addr         :string
#  last_heard_from   :datetime
#  manufacturer_name :string
#  model             :string
#  network_address   :integer
#  power_source      :string
#  zcl_version       :integer
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#
# Indexes
#
#  index_devices_on_ieee_addr  (ieee_addr) UNIQUE
#
class Device < ApplicationRecord
  has_many :mqtt_messages, dependent: :destroy
  has_many :readings, dependent: :destroy
  
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
      threshold = [interval_hours * 2, 1.0].max
      [threshold, 168.0].min
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
    return 'Disabled' unless monitoring_enabled?
    is_responsive? ? 'Responsive' : 'Non-Responsive'
  end
  
  # Time exceeded in hours (for non-responsive devices)
  def hours_exceeded
    return 0 unless alert_threshold_exceeded?
    time_since_last_message - alert_threshold_hours
  end

  # Prune messages inexcess of capture_max
  def prune
    # If capture_max is set for this device, prune messages in excess of capture_max
    unless capture_max.nil?
      # Find the IDs of the messages to keep
      kept_messages = mqtt_messages.order(created_at: :desc).limit(capture_max).pluck(:id)

      # Delete messages not included in kept_messages
      mqtt_messages.each do |message|
        unless kept_messages.include?(message.id)
          # Remove associated readings first
          message.readings.destroy_all
          # And then remove the message itself
          message.destroy
        end
      end
    end
  end
end

class AddMonitoringToDevices < ActiveRecord::Migration[8.0]
  def up
    add_column :devices, :alert_threshold_hours, :decimal, precision: 10, scale: 2
    add_column :devices, :monitoring_enabled, :boolean, default: true
    add_column :devices, :last_alert_at, :datetime
    add_column :devices, :is_responsive, :boolean, default: true
    add_column :devices, :last_checked_at, :datetime

    add_index :devices, :monitoring_enabled
    add_index :devices, :is_responsive
    
    # Calculate initial thresholds based on message intervals
    Device.reset_column_information
    Device.find_each do |device|
      messages = device.mqtt_messages.order(created_at: :desc).limit(2).pluck(:created_at)
      
      if messages.count == 2
        # Calculate interval between last two messages
        interval_seconds = (messages[0] - messages[1]).abs
        interval_hours = interval_seconds / 3600.0
        
        # Set threshold to 2x the interval, with a minimum of 1 hour and maximum of 168 hours (1 week)
        threshold = [interval_hours * 2, 1.0].max
        threshold = [threshold, 168.0].min
        
        device.update_column(:alert_threshold_hours, threshold)
      else
        # Default to 24 hours if insufficient message data
        device.update_column(:alert_threshold_hours, 24.0)
      end
      
      # Initialize responsiveness based on current status
      if device.last_heard_from.present?
        hours_since_last = (Time.current - device.last_heard_from) / 3600.0
        threshold = device.alert_threshold_hours || 24.0
        device.update_column(:is_responsive, hours_since_last <= threshold)
      end
      
      device.update_column(:last_checked_at, Time.current)
    end
  end

  def down
    remove_index :devices, :is_responsive
    remove_index :devices, :monitoring_enabled
    
    remove_column :devices, :last_checked_at
    remove_column :devices, :is_responsive
    remove_column :devices, :last_alert_at
    remove_column :devices, :monitoring_enabled
    remove_column :devices, :alert_threshold_hours
  end
end

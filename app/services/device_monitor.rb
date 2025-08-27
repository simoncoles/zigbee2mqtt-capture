class DeviceMonitor
  class << self
    def check_all_devices
      start_time = Time.current
      checked_count = 0
      error_count = 0
      status_changes = { became_responsive: 0, became_non_responsive: 0 }

      Rails.logger.info "[DeviceMonitor] Starting device monitoring check..."

      # Process devices in batches to avoid memory issues
      batch_size = ENV.fetch("MONITOR_BATCH_SIZE", 50).to_i

      Device.monitored.find_in_batches(batch_size: batch_size) do |batch|
        batch.each do |device|
          begin
            result = check_device(device)
            checked_count += 1

            # Track status changes
            if result[:status_changed]
              if device.is_responsive?
                status_changes[:became_responsive] += 1
                Rails.logger.info "[DeviceMonitor] Device became responsive: #{device.friendly_name || device.ieee_addr}"
              else
                status_changes[:became_non_responsive] += 1
                Rails.logger.warn "[DeviceMonitor] Device became non-responsive: #{device.friendly_name || device.ieee_addr} (threshold: #{device.alert_threshold_hours}h)"
              end
            end
          rescue => e
            error_count += 1
            Rails.logger.error "[DeviceMonitor] Error checking device #{device.id}: #{e.message}"
            Rails.logger.debug e.backtrace.join("\n") if Rails.env.development?
          end
        end

        # Log progress for large networks
        if checked_count % 100 == 0
          Rails.logger.debug "[DeviceMonitor] Progress: checked #{checked_count} devices..."
        end  end

      duration = (Time.current - start_time).round(2)

      Rails.logger.info "[DeviceMonitor] Check completed in #{duration}s - Checked: #{checked_count}, Errors: #{error_count}, " \
                       "Became responsive: #{status_changes[:became_responsive]}, Became non-responsive: #{status_changes[:became_non_responsive]}"

      {
        checked_count: checked_count,
        error_count: error_count,
        duration: duration,
        status_changes: status_changes
      }
    end
    def check_device(device)
      return { status_changed: false, error: "Monitoring disabled" } unless device.monitoring_enabled?

      previous_status = device.is_responsive
      previous_alert = device.last_alert_at

      # Use the model's check_responsiveness method
      device.check_responsiveness

      status_changed = previous_status != device.is_responsive
      new_alert = previous_alert != device.last_alert_at

      # Log individual device checks in debug mode
      if ENV["MONITOR_DEBUG"] == "true"
        hours_since = device.time_since_last_message.round(2)
        Rails.logger.debug "[DeviceMonitor] Checked #{device.friendly_name || device.ieee_addr}: " \
                          "responsive=#{device.is_responsive}, hours_since_last=#{hours_since}, " \
                          "threshold=#{device.alert_threshold_hours}"
      end

      {
        status_changed: status_changed,
        new_alert: new_alert,
        is_responsive: device.is_responsive
      }
    end
    def summary_stats
      total = Device.count
      monitored = Device.monitored.count
      responsive = Device.responsive.count
      non_responsive = Device.non_responsive.count
      disabled = Device.where(monitoring_enabled: false).count

      # Calculate average threshold
      thresholds = Device.monitored.pluck(:alert_threshold_hours).compact
      avg_threshold = thresholds.any? ? (thresholds.sum / thresholds.count).round(2) : 0

      {
        total_devices: total,
        monitored_devices: monitored,
        responsive_devices: responsive,
        non_responsive_devices: non_responsive,
        monitoring_disabled: disabled,
        average_threshold_hours: avg_threshold,
        response_rate: monitored > 0 ? ((responsive.to_f / monitored) * 100).round(2) : 0
      }
    end
    def reset_device(device)
      # Utility method to reset a device's monitoring state
      device.update(
        is_responsive: true,
        last_alert_at: nil,
        last_checked_at: Time.current
      )
    end
  end
end

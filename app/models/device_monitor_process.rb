class DeviceMonitorProcess
  class << self
    attr_accessor :running

    def run
      # Check if monitoring is enabled globally
      unless ENV.fetch("MONITOR_ENABLED", "true") == "true"
        Rails.logger.info "[DeviceMonitorProcess] Monitoring is disabled via MONITOR_ENABLED environment variable"
        return
      end

      Rails.logger.info "[DeviceMonitorProcess] Starting device monitoring process..."
      Rails.logger.info "[DeviceMonitorProcess] Check interval: #{check_interval} seconds"
      Rails.logger.info "[DeviceMonitorProcess] Batch size: #{ENV.fetch('MONITOR_BATCH_SIZE', 50)}"

      # Set up signal handlers for graceful shutdown
      setup_signal_handlers

      @running = true
      last_summary_log = Time.current

      while @running
        begin
          # Run the monitoring check
          result = DeviceMonitor.check_all_devices

          # Log summary stats periodically (every hour)
          if Time.current - last_summary_log > 3600
            log_summary_stats
            last_summary_log = Time.current
          end

          # Sleep for the configured interval
          sleep_with_interruption(check_interval)

        rescue ActiveRecord::ConnectionTimeoutError, ActiveRecord::ConnectionNotEstablished => e
          Rails.logger.error "[DeviceMonitorProcess] Database connection error: #{e.message}"
          Rails.logger.info "[DeviceMonitorProcess] Attempting to reconnect..."

          # Try to reconnect
          ActiveRecord::Base.clear_active_connections!
          sleep_with_interruption(30) # Wait before retrying

        rescue StandardError => e
          Rails.logger.error "[DeviceMonitorProcess] Unexpected error: #{e.message}"
          Rails.logger.error e.backtrace.join("\n") if Rails.env.development?

          # Continue running but wait a bit before next iteration
          sleep_with_interruption(60)
        end
      end

      Rails.logger.info "[DeviceMonitorProcess] Monitoring process stopped"
    end

    def stop
      Rails.logger.info "[DeviceMonitorProcess] Stopping monitoring process..."
      @running = false
    end

    private

    def check_interval
      @check_interval ||= ENV.fetch("MONITOR_CHECK_INTERVAL", 300).to_i
    end

    def setup_signal_handlers
      # Handle graceful shutdown
      [ "TERM", "INT" ].each do |signal|
        Signal.trap(signal) do
          Rails.logger.info "[DeviceMonitorProcess] Received #{signal} signal, shutting down gracefully..."
          stop
        end
      end

      # Handle USR1 for status report
      Signal.trap("USR1") do
        log_summary_stats
      end
    rescue ArgumentError
      # Some signals might not be available on all platforms
      Rails.logger.debug "[DeviceMonitorProcess] Could not set up all signal handlers"
    end

    def sleep_with_interruption(seconds)
      # Sleep in small increments to allow for faster shutdown
      remaining = seconds
      while remaining > 0 && @running
        sleep_time = [ remaining, 1 ].min
        sleep(sleep_time)
        remaining -= sleep_time
      end
    end

    def log_summary_stats
      stats = DeviceMonitor.summary_stats

      Rails.logger.info "[DeviceMonitorProcess] Summary Stats:"
      Rails.logger.info "  Total devices: #{stats[:total_devices]}"
      Rails.logger.info "  Monitored: #{stats[:monitored_devices]}"
      Rails.logger.info "  Responsive: #{stats[:responsive_devices]} (#{stats[:response_rate]}%)"
      Rails.logger.info "  Non-responsive: #{stats[:non_responsive_devices]}"
      Rails.logger.info "  Monitoring disabled: #{stats[:monitoring_disabled]}"
      Rails.logger.info "  Average threshold: #{stats[:average_threshold_hours]} hours"
    end
  end
end

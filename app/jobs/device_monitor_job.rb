class DeviceMonitorJob < ApplicationJob
  queue_as :default

  def perform
    return unless ENV.fetch("MONITOR_ENABLED", "true") == "true"
    DeviceMonitor.check_all_devices
  end
end

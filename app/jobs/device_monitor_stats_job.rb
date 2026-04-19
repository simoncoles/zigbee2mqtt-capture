class DeviceMonitorStatsJob < ApplicationJob
  queue_as :default

  def perform
    stats = DeviceMonitor.summary_stats

    Rails.logger.info "[DeviceMonitorStatsJob] Summary Stats:"
    Rails.logger.info "  Total devices: #{stats[:total_devices]}"
    Rails.logger.info "  Monitored: #{stats[:monitored_devices]}"
    Rails.logger.info "  Responsive: #{stats[:responsive_devices]} (#{stats[:response_rate]}%)"
    Rails.logger.info "  Non-responsive: #{stats[:non_responsive_devices]}"
    Rails.logger.info "  Monitoring disabled: #{stats[:monitoring_disabled]}"
    Rails.logger.info "  Average threshold: #{stats[:average_threshold_hours]} hours"
  end
end

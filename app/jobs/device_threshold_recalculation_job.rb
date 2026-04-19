class DeviceThresholdRecalculationJob < ApplicationJob
  queue_as :default

  def perform
    DeviceMonitor.recalculate_all_thresholds
  end
end

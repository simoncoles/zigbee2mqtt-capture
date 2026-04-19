class DevicePruneJob < ApplicationJob
  queue_as :default

  def perform
    Device.where.not(capture_max: nil).find_each(&:prune)
  end
end

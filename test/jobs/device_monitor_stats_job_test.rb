require "test_helper"

class DeviceMonitorStatsJobTest < ActiveJob::TestCase
  test "logs summary stats from DeviceMonitor" do
    io = StringIO.new
    original_logger = Rails.logger
    Rails.logger = Logger.new(io)
    begin
      DeviceMonitorStatsJob.perform_now
    ensure
      Rails.logger = original_logger
    end

    output = io.string
    assert_match(/Summary Stats:/, output)
    assert_match(/Total devices: #{Device.count}/, output)
  end
end

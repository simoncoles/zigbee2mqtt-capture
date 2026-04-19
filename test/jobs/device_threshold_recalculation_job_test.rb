require "test_helper"

class DeviceThresholdRecalculationJobTest < ActiveJob::TestCase
  test "logs the recalculation result" do
    io = StringIO.new
    original_logger = Rails.logger
    Rails.logger = Logger.new(io)
    begin
      DeviceThresholdRecalculationJob.perform_now
    ensure
      Rails.logger = original_logger
    end

    assert_match(/Recalculated thresholds:/, io.string)
  end
end

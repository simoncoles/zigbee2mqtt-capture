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
require "test_helper"

class DeviceTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end

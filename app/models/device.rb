# == Schema Information
#
# Table name: devices
#
#  id                :bigint           not null, primary key
#  device_type       :string
#  friendly_name     :string
#  ieee_addr         :string
#  manufacturer_name :string
#  model             :string
#  network_address   :integer
#  power_source      :string
#  zcl_version       :integer
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#
class Device < ApplicationRecord
  has_many :mqtt_messages
end

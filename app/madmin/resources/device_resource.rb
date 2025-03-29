class DeviceResource < Madmin::Resource
  # Attributes
  attribute :id, form: false
  attribute :friendly_name
  attribute :ieee_addr
  attribute :manufacturer_name
  attribute :model
  attribute :network_address
  attribute :power_source
  attribute :device_type
  attribute :zcl_version
  attribute :created_at, form: false
  attribute :updated_at, form: false
  attribute :capture_max
  attribute :last_heard_from

  # Associations
  attribute :mqtt_messages
  attribute :readings

  # Add scopes to easily filter records
  # scope :published

  # Add actions to the resource's show page
  # member_action do |record|
  #   link_to "Do Something", some_path
  # end

  # Customize the display name of records in the admin area.
  def self.display_name(record) = record.friendly_name

  # Customize the default sort column and direction.
  # def self.default_sort_column = "created_at"
  #
  # def self.default_sort_direction = "desc"
end

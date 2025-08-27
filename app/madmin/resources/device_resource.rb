class DeviceResource < Madmin::Resource
  # Attributes
  attribute :id, form: false
  attribute :friendly_name, index: true
  attribute :ieee_addr
  attribute :manufacturer_name
  attribute :model
  attribute :network_address
  attribute :power_source
  attribute :device_type
  attribute :zcl_version
  attribute :created_at, form: false, index: false
  attribute :updated_at, form: false
  attribute :capture_max
  attribute :last_heard_from, index: true
  
  # Monitoring attributes
  attribute :alert_threshold_hours
  attribute :monitoring_enabled
  attribute :is_responsive, form: false, index: true
  attribute :last_alert_at, form: false
  attribute :last_checked_at, form: false

  # Associations
  attribute :mqtt_messages
  attribute :readings

  # Add scopes to easily filter records
  scope :non_responsive
  scope :responsive
  scope :monitored

  # Add actions to the resource's show page
  member_action do |record|
    if record.monitoring_enabled?
      link_to "Disable Monitoring", 
              madmin_device_path(record, device: { monitoring_enabled: false }),
              method: :patch,
              class: "btn btn-sm btn-warning",
              data: { turbo_method: :patch }
    else
      link_to "Enable Monitoring", 
              madmin_device_path(record, device: { monitoring_enabled: true }),
              method: :patch,
              class: "btn btn-sm btn-success",
              data: { turbo_method: :patch }
    end
  end
  
  member_action do |record|
    if record.alert_threshold_exceeded?
      link_to "Reset Alert", 
              madmin_device_path(record, device: { is_responsive: true, last_alert_at: nil }),
              method: :patch,
              class: "btn btn-sm btn-info",
              data: { turbo_method: :patch }
    end
  end

  # Customize the display name of records in the admin area.
  def self.display_name(record)
    status = if !record.monitoring_enabled?
               "🔕"
             elsif record.is_responsive?
               "✅"
             else
               "⚠️"
             end
    "#{status} #{record.friendly_name || record.ieee_addr}"
  end

  # Customize the default sort column and direction.
  # def self.default_sort_column = "created_at"
  #
  # def self.default_sort_direction = "desc"
end

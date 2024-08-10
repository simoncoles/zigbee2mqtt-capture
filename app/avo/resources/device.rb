class Avo::Resources::Device < Avo::BaseResource
  # self.includes = []
  # self.attachments = []
  # self.search = {
  #   query: -> { query.ransack(id_eq: params[:q], m: "or").result(distinct: false) }
  # }

  def fields
    field :preview, as: :preview
    field :id, as: :id, sortable: true
    field :last_heard_from, as: :date_time, sortable: true
    field :friendly_name, as: :text, sortable: true
    field :capture_max, as: :number, hide_on: [ :index ]
    field :ieee_addr, as: :text, hide_on: [ :index ]
    field :manufacturer_name, as: :text, hide_on: [ :index ]
    field :model, as: :text, sortable: true
    field :network_address, as: :number, hide_on: [ :index ]
    field :power_source, as: :text, hide_on: [ :index ]
    field :device_type, as: :text, sortable: true
    field :zcl_version, as: :number, hide_on: [ :index ]
    field :link_to_zigbee2mqtt, as: :text, hide_on: [ :index ] do
        "#{ENV['ZIGBEE2MQTT_BASE']}/#/device/#{record.ieee_addr}/info"
      end
    field :mqtt_messages, as: :has_many, show_on: :preview
  end
end

class Avo::Resources::Device < Avo::BaseResource
  # self.includes = []
  # self.attachments = []
  # self.search = {
  #   query: -> { query.ransack(id_eq: params[:q], m: "or").result(distinct: false) }
  # }

  def fields
    field :id, as: :id
    field :friendly_name, as: :text
    field :ieee_addr, as: :text
    field :manufacturer_name, as: :text
    field :model, as: :text
    field :network_address, as: :number
    field :power_source, as: :text
    field :device_type, as: :text
    field :zcl_version, as: :number
    field :mqtt_messages, as: :has_many

  end
end

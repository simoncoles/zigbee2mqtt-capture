class Avo::Resources::Reading < Avo::BaseResource
  # self.includes = []
  # self.attachments = []
  # self.search = {
  #   query: -> { query.ransack(id_eq: params[:q], m: "or").result(distinct: false) }
  # }

  def fields
    field :id, as: :id, sortable: true
    field :key, as: :text, sortable: true
    field :value, as: :text, sortable: true
    field :mqtt_message_id, as: :number
    field :mqtt_message, as: :belongs_to, can_create: false
    field :device, as: :belongs_to, can_create: false
  end
end

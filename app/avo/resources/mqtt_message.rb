class Avo::Resources::MqttMessage < Avo::BaseResource
  # self.includes = []
  # self.attachments = []
  # self.search = {
  #   query: -> { query.ransack(id_eq: params[:q], m: "or").result(distinct: false) }
  # }

  def fields
    field :id, as: :id
    field :topic, as: :text
    field :content, as: :textarea
    field :friendly_name, as: :text
    field :formatted_json, as: :textarea
    field :model, as: :text
    field :device, as: :belongs_to, can_create: false
  end
end

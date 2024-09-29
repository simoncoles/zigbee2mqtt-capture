class Avo::Resources::MqttMessage < Avo::BaseResource
  # self.includes = []
  # self.attachments = []
  # self.search = {
  #   query: -> { query.ransack(id_eq: params[:q], m: "or").result(distinct: false) }
  # }

  def fields
    field :preview, as: :preview
    field :id, as: :id, sortable: true
    field :created_at, as: :date_time, sortable: true
    field :topic, as: :text
    field :friendly_name, as: :text, sortable: true
    field :formatted_json, as: :code, language: "json", show_on: :preview
    field :model, as: :text, sortable: true
    field :device, as: :belongs_to, can_create: false, hide_on: [ :index ]
    field :readings, as: :has_many
  end
  self.title = :topic
end

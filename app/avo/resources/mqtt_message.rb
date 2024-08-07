class Avo::Resources::MqttMessage < Avo::BaseResource
  # self.includes = []
  # self.attachments = []
  # self.search = {
  #   query: -> { query.ransack(id_eq: params[:q], m: "or").result(distinct: false) }
  # }

  def fields
    field :id, as: :id, sortable: true
    field :topic, as: :text, sortable: true
    field :created_at, as: :date_time, sortable: true
    field :friendly_name, as: :text, sortable: true
    field :model, as: :text, sortable: true
    field :content, as: :textarea
    field :formatted_json, as: :code
  end


end

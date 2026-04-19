class RawMqttMessagesController < ApplicationController
  include Sortable

  SORTABLE_COLUMNS = %w[topic created_at retained qos].freeze

  def index
    messages = RawMqttMessage.search(params[:q]).includes(:mqtt_topic)
    messages = apply_sort(messages, allowed_columns: SORTABLE_COLUMNS, default_column: "created_at")
    @pagy, @raw_mqtt_messages = pagy(messages)
  end

  def show
    @raw_mqtt_message = RawMqttMessage.includes(:mqtt_topic).find(params[:id])
  end
end

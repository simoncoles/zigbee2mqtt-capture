class MqttMessagesController < ApplicationController
  include Sortable

  DEVICE_SORTABLE_COLUMNS = %w[topic friendly_name model created_at].freeze
  SYSTEM_SORTABLE_COLUMNS = %w[topic friendly_name category created_at].freeze
  COMMAND_SORTABLE_COLUMNS = %w[topic friendly_name created_at].freeze

  def index
    messages = MqttMessage.device_messages.search(params[:q]).includes(:device)
    messages = apply_sort(messages, allowed_columns: DEVICE_SORTABLE_COLUMNS, default_column: "created_at")
    @pagy, @mqtt_messages = pagy(messages)
  end

  def show
    @mqtt_message = MqttMessage.find(params[:id])
  end

  def system
    messages = MqttMessage.non_device_messages.search(params[:q])
    messages = apply_sort(messages, allowed_columns: SYSTEM_SORTABLE_COLUMNS, default_column: "created_at")
    @pagy, @mqtt_messages = pagy(messages)
  end

  def commands
    messages = MqttMessage.command_messages.search(params[:q]).includes(:device)
    messages = apply_sort(messages, allowed_columns: COMMAND_SORTABLE_COLUMNS, default_column: "created_at")
    @pagy, @mqtt_messages = pagy(messages)
  end
end

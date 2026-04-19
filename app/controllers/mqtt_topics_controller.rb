class MqttTopicsController < ApplicationController
  include Sortable

  INDEX_SORTABLE_COLUMNS = %w[name message_count first_seen_at last_seen_at handled].freeze
  SHOW_SORTABLE_COLUMNS  = %w[topic created_at retained qos].freeze

  def index
    topics = MqttTopic.search(params[:q])
    topics = topics.unhandled if params[:filter] == "unhandled"
    topics = apply_sort(topics, allowed_columns: INDEX_SORTABLE_COLUMNS, default_column: "last_seen_at")
    @filter = params[:filter] == "unhandled" ? "unhandled" : "all"
    @pagy, @mqtt_topics = pagy(topics)
  end

  def show
    @mqtt_topic = MqttTopic.find(params[:id])
    messages = @mqtt_topic.raw_mqtt_messages.search(params[:q])
    messages = apply_sort(messages, allowed_columns: SHOW_SORTABLE_COLUMNS, default_column: "created_at")
    @pagy, @raw_mqtt_messages = pagy(messages)
  end
end

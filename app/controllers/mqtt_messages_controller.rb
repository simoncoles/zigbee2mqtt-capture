class MqttMessagesController < ApplicationController
  def index
    messages = MqttMessage.search(params[:q]).order(created_at: :desc)
    @pagy, @mqtt_messages = pagy(messages)
  end
end

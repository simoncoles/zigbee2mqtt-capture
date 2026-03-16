class MqttMessagesController < ApplicationController
  def index
    messages = MqttMessage.device_messages.search(params[:q]).includes(:device).order(created_at: :desc)
    @pagy, @mqtt_messages = pagy(messages)
  end

  def show
    @mqtt_message = MqttMessage.find(params[:id])
  end

  def system
    messages = MqttMessage.non_device_messages.search(params[:q]).order(created_at: :desc)
    @pagy, @mqtt_messages = pagy(messages)
  end
end

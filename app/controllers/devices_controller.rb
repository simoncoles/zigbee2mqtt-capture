class DevicesController < ApplicationController
  def index
    devices = Device.search(params[:q]).order(last_heard_from: :desc)
    @pagy, @devices = pagy(devices)
  end
end

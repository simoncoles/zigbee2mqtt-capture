class ReadingsController < ApplicationController
  def index
    readings = Reading.search(params[:q]).includes(:device).order(created_at: :desc)
    @pagy, @readings = pagy(readings)
  end
end

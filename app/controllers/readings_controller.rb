class ReadingsController < ApplicationController
  include Sortable

  SORTABLE_COLUMNS = %w[devices.friendly_name key value created_at].freeze

  def index
    readings = Reading.search(params[:q]).includes(:device).references(:device)
    readings = apply_sort(readings, allowed_columns: SORTABLE_COLUMNS, default_column: "created_at")
    @pagy, @readings = pagy(readings)
  end
end

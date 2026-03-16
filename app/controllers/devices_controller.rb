class DevicesController < ApplicationController
  include Sortable

  SORTABLE_COLUMNS = %w[friendly_name ieee_addr manufacturer_name model power_source last_heard_from].freeze

  def index
    devices = Device.search(params[:q])
    devices = apply_sort(devices, allowed_columns: SORTABLE_COLUMNS, default_column: "last_heard_from")
    @pagy, @devices = pagy(devices)
  end
end

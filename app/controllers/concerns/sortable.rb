module Sortable
  extend ActiveSupport::Concern

  private

  def apply_sort(scope, allowed_columns:, default_column:, default_direction: "desc")
    @sort_column = allowed_columns.include?(params[:sort]) ? params[:sort] : default_column
    @sort_direction = %w[asc desc].include?(params[:direction]) ? params[:direction] : default_direction
    scope.order(@sort_column => @sort_direction)
  end
end

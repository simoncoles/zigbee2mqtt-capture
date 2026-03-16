module ApplicationHelper
  include Pagy::HelperLoader
  include Pagy::NumericHelperLoader

  def sortable_header(title, column)
    active = @sort_column == column
    if active && @sort_direction == "asc"
      new_direction = "desc"
      arrow = " ▲"
    else
      new_direction = "asc"
      arrow = active ? " ▼" : ""
    end

    sort_params = request.query_parameters.merge(sort: column, direction: new_direction, page: nil)
    link_class = "group inline-flex items-center px-3 py-3 text-left text-xs font-medium uppercase tracking-wider #{active ? 'text-blue-600' : 'text-gray-500 hover:text-gray-700'}"

    content_tag(:th) do
      link_to(title + arrow, url_for(sort_params), class: link_class)
    end
  end
end

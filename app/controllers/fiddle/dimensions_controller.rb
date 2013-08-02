class Fiddle::DimensionsController < Fiddle::BaseController
  inherit_resources
  defaults   route_prefix: "", resource_class: parent::Dimension
  belongs_to :cube, parent_class: parent::Cube, shallow: true

  def permitted_params
    params.permit dimension: [:name, :description, :clause, :sortable, :type_code, :visible]
  end
end

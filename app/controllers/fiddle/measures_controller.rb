class Fiddle::MeasuresController < Fiddle::BaseController
  inherit_resources
  defaults   route_prefix: "", resource_class: parent::Measure
  belongs_to :cube, parent_class: parent::Cube, shallow: true

  def permitted_params
    params.permit measure: [:name, :description, :clause, :sortable, :type_code]
  end
end

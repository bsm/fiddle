class Fiddle::ConstraintsController < Fiddle::BaseController
  inherit_resources
  defaults   :route_prefix => "", :resource_class => parent::Constraint
  belongs_to :cube, :parent_class => parent::Cube, :shallow => true

  def permitted_params
    params.permit constraint: [:name, :projection_id, :operation_code]
  end
end

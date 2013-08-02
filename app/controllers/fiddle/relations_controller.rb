class Fiddle::RelationsController < Fiddle::BaseController
  inherit_resources
  defaults   :route_prefix => "", :resource_class => parent::Relation
  belongs_to :cube, :parent_class => parent::Cube, :shallow => true

  def permitted_params
    params.permit relation: [:name, :target, :predicate, :operator]
  end
end

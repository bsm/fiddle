class Fiddle::RelationsController < Fiddle::BaseController
  inherit_resources
  defaults   :route_prefix => "", :resource_class => parent::Relation
  belongs_to :cube, :parent_class => parent::Cube, :shallow => true
end

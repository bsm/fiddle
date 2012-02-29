class Fiddle::LookupsController < Fiddle::BaseController
  inherit_resources
  defaults   :route_prefix => "", :resource_class => parent::Lookup
  belongs_to :cube, :parent_class => parent::Cube, :shallow => true
end
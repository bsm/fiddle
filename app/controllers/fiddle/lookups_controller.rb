class Fiddle::LookupsController < Fiddle::BaseController
  inherit_resources
  defaults   :route_prefix => "", :resource_class => parent::Lookup
  belongs_to :universe, :parent_class => parent::Universe, :shallow => true
end
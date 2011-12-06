class Fiddle::UniversesController < Fiddle::BaseController
  inherit_resources
  defaults :route_prefix => "", :resource_class => parent::Universe
end

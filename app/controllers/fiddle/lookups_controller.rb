class Fiddle::LookupsController < Fiddle::BaseController
  inherit_resources
  defaults   :route_prefix => "", :resource_class => parent::Lookup
  belongs_to :universe, :parent_class => parent::Universe, :shallow => true

  def permitted_params
    params.permit lookup: [:name, :clause, :label_clause, :value_clause, :parent_value_clause]
  end
end
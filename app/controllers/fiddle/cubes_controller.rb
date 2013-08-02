class Fiddle::CubesController < Fiddle::BaseController
  inherit_resources
  defaults   route_prefix: "", resource_class: parent::Cube
  belongs_to :universe, parent_class: parent::Universe, shallow: true

  def permitted_params
    params.permit cube: [:name, :clause]
  end if Fiddle.strong_parameters?
end

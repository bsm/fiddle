class Fiddle::UniversesController < Fiddle::BaseController
  inherit_resources
  defaults route_prefix: "", resource_class: parent::Universe

  def permitted_params
    params.permit universe: [:name, :uri]
  end if Fiddle.strong_parameters?
end

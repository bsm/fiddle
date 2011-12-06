Fiddle::Engine.routes.draw do

  root :to => "universes#index"

  resources :universes do
    resources :cubes, :shallow => true do
      resources :relations, :dimensions, :measures, :constraints, :shallow => true
    end
  end

end

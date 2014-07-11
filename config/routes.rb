Fiddle::Engine.routes.draw do

  root :to => "universes#index"

  resources :universes, shallow: true do
    resources :cubes, shallow: true do
      resources :relations, :dimensions, :measures, :constraints, shallow: true
    end
    resources :lookups, shallow: true
  end

end

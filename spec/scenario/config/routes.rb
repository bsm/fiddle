Dummy::Application.routes.draw do
  root :to => "home#index"
  mount Fiddle::Engine => "/my"
end

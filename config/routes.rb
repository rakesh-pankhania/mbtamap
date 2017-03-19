Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  resources :stops, only: [:index, :show]
  resources :services, only: [:index, :show]
  resources :trips, only: [:index, :show]
  resources :routes, only: [:index, :show]
  resources :agencies, only: [:index, :show]
end

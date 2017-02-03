Rails.application.routes.draw do
  resources :routes
  resources :agencies
  resources :feeds
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end

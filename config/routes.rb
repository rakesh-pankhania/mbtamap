Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  get root to: 'routes#index'

  get 'routes/:id', to: redirect('/routes/%{id}/outbound')
  get 'routes/:id/:direction', to:'routes#show'

  resources :routes, only: [:index, :show]
end

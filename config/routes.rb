Rails.application.routes.draw do
  get root to: 'routes#index'

  get 'routes/:id', to: redirect('/routes/%{id}/outbound')
  get 'routes/:id/:direction', to:'routes#show', constraints: { direction: /inbound|outbound/}

  resources :routes, only: [:index, :show]
end

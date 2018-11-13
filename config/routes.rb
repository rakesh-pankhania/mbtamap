Rails.application.routes.draw do
  get root to: 'routes#index'

  get 'routes/:id', to: redirect('/routes/%{id}/outbound')
  get 'routes/:id/:direction', to: 'routes#show', constraints: { direction: /inbound|outbound/}, as: :route_direction
  get 'routes/:id/:direction/vehicles', to: 'routes#vehicles', constraints: { direction: /inbound|outbound/}, as: :route_direction_vehicles

  resources :routes, only: [:index, :show]
end

Rails.application.routes.draw do
  get root to: 'routes#index'

  get '/:id', to: redirect('/routes/%{id}/outbound')
  get '/:id/:direction', to: 'routes#show', constraints: { direction: /inbound|outbound/}, as: :route_direction
  get '/:id/:direction/vehicles', to: 'routes#vehicles', constraints: { direction: /inbound|outbound/}, as: :route_direction_vehicles

  resources :routes, only: [:index]
end

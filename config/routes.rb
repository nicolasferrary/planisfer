Rails.application.routes.draw do
  get 'trips/index'

  get 'trips/show'

  get 'trips/update'

  get 'trips/create'

  get 'trips/destroy'

  get 'round_trip_flight/create'

  get 'round_trip_flight/destroy'

  get 'regions/create'

  get 'regions/destroy'

  get 'cities/create'

  get 'cities/destroy'

 get 'regions/create'

 get 'cities/create'

 get 'round_trip_flights/create'

 get 'trips/index'

 get 'trips/show'

 get 'trips/update'

 get 'trips/create'

 root to: 'pages#home'
 resources :trips, only: [:index, :show, :update, :create]
 resources :round_trip_flights, only: [:create]
 # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end

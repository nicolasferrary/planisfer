Rails.application.routes.draw do


 root to: 'pages#home'
 resources :trips, only: [:index, :show, :update, :create]
 resources :round_trip_flights, only: [:create]
 # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end

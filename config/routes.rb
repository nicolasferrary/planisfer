Rails.application.routes.draw do
  root to: 'pages#home'
  resources :searches, only: [:create, :show]
  resources :trips, only: [:index, :show, :update, :create]do
    get :refresh_map, to: "searches#refresh_map"
  end
  resources :round_trip_flights, only: [:create]
  resources :selections, only: [:create, :show]
  resources :airports
  resources :orders, only: [:show, :create] do
    resources :payments, only: [:new, :create]
  end
  resources :users, only: [:create, :update]

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end

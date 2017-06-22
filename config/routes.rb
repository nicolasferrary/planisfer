Rails.application.routes.draw do
  devise_for :members,
    controllers: { omniauth_callbacks: 'members/omniauth_callbacks' }
  root to: 'pages#home'
  resources :searches, only: [:create, :show]
  resources :trips, only: [:index, :show, :update, :create]do
    get :refresh_map, to: "searches#refresh_map"
  end
  resources :round_trip_flights, only: [:create]
  resources :selections, only: [:create, :show]
  resources :airports, only: [:show] do
    get :highlight_airport, to: "searches#highlight_airport"
  end
  resources :orders, only: [:show, :create, :update] do
    resources :payments, only: [:new, :create]
  end
  get :add_question, to: "orders#add_question_to_order"
  resources :pois, only: [:show] do
    get :highlight_poi, to: "searches#highlight_poi"
  end
  resources :activities, only: [:create, :update]
  resources :experiences, only: [:create, :update]
  resources :subexperiences, only: [:create, :new, :update]
  resources :profile, only: [:show]

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end

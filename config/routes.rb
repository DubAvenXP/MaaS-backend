Rails.application.routes.draw do
  resources :shifts
  resources :services
  resources :clients
  resources :availabilities
  resources :profiles, only: %i[update]
  resources :users
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
end

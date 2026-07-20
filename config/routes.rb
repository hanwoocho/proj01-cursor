Rails.application.routes.draw do
  get "up" => "rails/health#show", as: :rails_health_check

  root "rooms#index"

  get    "login",  to: "sessions#new"
  post   "login",  to: "sessions#create"
  delete "logout", to: "sessions#destroy"

  get  "signup", to: "users#new"
  post "signup", to: "users#create"

  resources :rooms, only: [ :index, :show, :create ] do
    resources :messages, only: [ :create ]
  end

  namespace :admin do
    resources :users, only: [ :index, :destroy ]
  end
end

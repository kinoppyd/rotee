Rails.application.routes.draw do
  resources :dashboards, except: %i[index] do
    resources :lists, only: %i[new create]
  end

  resources :lists, only: %i[show edit update destroy] do
    resources :items, only: %i[new create]
  end

  resources :items, only: %i[show edit update destroy]
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  root "static_pages#root"
end

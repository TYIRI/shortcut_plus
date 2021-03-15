Rails.application.routes.draw do
  resources :users
  resources :recipes

  get '/login', to: 'sessions#new'
  post '/login', to: 'sessions#create'
  post '/logout', to: 'sessions#destroy'

  root 'recipes#index'
end

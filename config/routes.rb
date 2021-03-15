Rails.application.routes.draw do
  resources :users
  resources :recipes

  get '/login', to: 'sessions#new'
  post '/login', to: 'sessions#create'

  root 'recipes#index'
end

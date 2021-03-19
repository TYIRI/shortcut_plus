Rails.application.routes.draw do
  resources :users, only: %i[new create]
  resources :categories, only: %i[show]
  resources :recipes, shallow: true, only: %i[new create show edit update destroy] do
    resources :comments, only: %i[create destroy]
  end

  get '/search', to: 'recipes#search'
  get '/login', to: 'sessions#new'
  post '/login', to: 'sessions#create'
  delete '/logout', to: 'sessions#destroy'
  root 'recipes#index'

  resources :users, path: '/', only: %i[show edit update destroy]
end

Rails.application.routes.draw do
  resources :users
  resources :categories, only: %i[show]
  resources :recipes, shallow: true do
    resources :comments, only: %i[create destroy]
  end

  get '/search', to: 'recipes#search'
  get '/login', to: 'sessions#new'
  post '/login', to: 'sessions#create'
  delete '/logout', to: 'sessions#destroy'

  root 'recipes#index'
end

Rails.application.routes.draw do
  resources :users, only: %i[new create] do
    member do
      get :activate
    end
  end
  resources :categories, only: %i[show]
  resources :recipes, shallow: true, only: %i[new create show edit update destroy] do
    resources :comments, only: %i[create destroy]
  end
  resources :recipe_likes, only: %i[create destroy]
  resources :comment_likes, only: %i[create destroy]
  resources :password_resets, only: %i[new create edit update]

  get '/settings', to: 'users#edit'
  get '/my_recipes', to: 'recipes#my_recipes'
  get '/search', to: 'recipes#search'
  get '/login', to: 'sessions#new'
  post '/login', to: 'sessions#create'
  delete '/logout', to: 'sessions#destroy'
  root 'recipes#index'

  mount LetterOpenerWeb::Engine, at: "/letter_opener" if Rails.env.development?
  resources :users, path: '/', only: %i[show edit update destroy]
end

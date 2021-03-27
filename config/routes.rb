Rails.application.routes.draw do
  resources :users, only: %i[new create edit update destroy] do
    member do
      get :activate
    end
  end
  resources :categories, only: %i[show]
  resources :tags, only: %i[show]
  resources :recipes, shallow: true, only: %i[new create show edit update destroy] do
    resources :comments, only: %i[create destroy]
    get 'get_tag_search', on: :collection, defaults: { format: 'json' }
    get 'get_tag_search', on: :member, defaults: { format: 'json' }
  end
  resources :recipe_likes, only: %i[create destroy]
  resources :comment_likes, only: %i[create destroy]
  resources :password_resets, only: %i[new create edit update]

  scope '/settings' do
    get '/', to: 'users#edit', as: :settings
    resources :email_changes, only: %i[new create edit]
  end

  get '/my_recipes', to: 'recipes#my_recipes'
  get '/search', to: 'recipes#search'
  get '/login', to: 'sessions#new'
  post '/login', to: 'sessions#create'
  delete '/logout', to: 'sessions#destroy'
  root 'recipes#index'

  mount LetterOpenerWeb::Engine, at: "/letter_opener" if Rails.env.development?
  get '/:id', to: 'users#show', as: :name
end

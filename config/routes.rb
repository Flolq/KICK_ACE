Rails.application.routes.draw do
  get 'matches/show'
  get 'players/index'
  get 'players/show'
  get 'messages/create'
  get 'chatrooms/show'
  devise_for :users
  root to: 'users#show'

  resources :users, only: [:show]
  resources :leagues, only: [:new, :create, :show, :edit, :update, :index] do
    resources :teams, only: [:new, :create, :edit, :update, :show]
    resources :chatrooms, only: [:show] do
      resources :messages, only: [:create]
    end
    resources :rounds, only: [:show]
  end
  resources :news, only: [:index]
  resources :players, only: [:index, :show] do
    resources :matches, only: :show
  end
end

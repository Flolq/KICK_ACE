Rails.application.routes.draw do
  require "sidekiq/web"
  authenticate :user, ->(user) { user.admin? } do
    mount Sidekiq::Web => '/sidekiq'
  end

  devise_for :users
  root to: 'users#show'

  resources :users, only: [:show]
  resources :leagues, only: [:new, :create, :show, :edit, :update, :index] do
    resources :teams, only: [:new, :create, :edit, :update, :show]
    resources :rounds, only: [:show]
  end

  resources :chatrooms, only: [:show] do
    resources :messages, only: [:create]
  end

  resources :selections, only: [:new, :create,:edit, :update, :destroy]

  resources :news, only: [:index]
  resources :players, only: [:index, :show] do
    resources :matches, only: [:show]
  end

  get "leagues/:league_id/teams/:id/bidding", to: "teams#bidding", as: :bidding
  get "leagues/:league_id/teams/:id/submitted", to: "teams#submitted", as: :submitted
  get "leagues/:league_id/teams/:id/final", to: "teams#final", as: :final
  get "leagues/token/:token", to: "leagues#token", as: :token

  resources :matches, only: [:index]


end

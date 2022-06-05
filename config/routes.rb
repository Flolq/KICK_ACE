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
    resources :chatrooms, only: [:show] do
      resources :messages, only: [:create]
    end
    resources :rounds, only: [:show]
  end

  resources :selections, only: [:new, :create,:edit, :update, :destroy]

  resources :news, only: [:index]
  resources :players, only: [:index, :show] do
    resources :matches, only: [:show]
  end
  resources :selections, only: [:update]

  get "leagues/:id/teams/:id/starting", to: "teams#starting", as: :starting
  get "leagues/:id/teams/:id/submitted", to: "teams#submitted", as: :submitted
  get "leagues/:id/teams/:id/final", to: "teams#final", as: :final

  resources :matches, only: [:index]

end

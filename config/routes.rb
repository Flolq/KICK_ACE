Rails.application.routes.draw do
  get 'messages/create'
  get 'chatrooms/show'
  devise_for :users
  root to: 'pages#home'

  resources :leagues, only: [:new, :create, :show] do
    resources :teams, only: [:create, :edit, :update, :show]
    resources :chatrooms, only: [:show] do
      resources :messages, only: [:create]
    end
    resources :rounds, only: [:show]
  end
  resources :news, only: [:index]
end

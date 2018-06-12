Rails.application.routes.draw do
  root 'twitter_users#index'
  resources :twitter_users, only: [:index, :create, :new, :show, :update]
  resources :markov_chains, only: [:create, :update]
end

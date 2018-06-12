Rails.application.routes.draw do
  root 'markov_chains#index'
  resources :markov_chains, only: [:index, :new, :create, :show]
end

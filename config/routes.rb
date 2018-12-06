Rails.application.routes.draw do

  devise_for :users
  root "products#index"

  namespace :admin do
    resources :products
    root "products#index"
  end

  resources :products, only: [:index, :show]
  resources :cartltem, only: 
end

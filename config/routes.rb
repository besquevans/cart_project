Rails.application.routes.draw do

  devise_for :users
  root "products#index"

  namespace :admin do
    root "products#index"
  end
end

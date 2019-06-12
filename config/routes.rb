Rails.application.routes.draw do

  devise_for :users, controllers: { omniauth_callbacks: 'users/omniauth_callbacks' }
  root "products#index"

  post "spgateway/return"
  post "spgateway/notify"


  resources :products, only: [:index, :show] do 
    post :add_to_cart, on: :member
    post :remove_from_cart, on: :member
    post :adjust_item, on: :member
    
    get :about, on: :collection
  end
  
  namespace :api, defaults: {format: :json} do
    namespace :v1 do
      post "/login" => "auth#login"
      post "/logout" => "auth#logout"

      resources :products, only: [:index, :show]
    end
  end

  resource :cart   #當你設定單數資源時，網址的表達會變成 /cart 而不是 /cart/:id，就會直接對應到 show action

  resources :orders do
    post :checkout_spgateway, on: :member
  end

  namespace :admin do
    resources :products
    resources :orders
    root "products#index"
  end
end

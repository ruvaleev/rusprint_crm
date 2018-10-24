Rails.application.routes.draw do

  root to: "orders#index"

  devise_for :users, controllers: { omniauth_callbacks: 'omniauth_callbacks' }
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  resources :messages do
    patch 'talk', on: :member
  end

<<<<<<< HEAD
  resources :orders do
    get 'get_printers', on: :member
  end
  
  resources :printers, shallow: true do
    get 'get_models', on: :member
  end

  resources :companies
  resources :prices
=======
  resources :orders
  resources :companies
>>>>>>> 9fa95f33637e92b13f9250f5a706008cbd4ef429
  
  resources :users  do
    patch 'make_friend', on: :member
  end

  mount ActionCable.server => '/cable'
end

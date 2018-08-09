Rails.application.routes.draw do

  root to: "orders#index"

  devise_for :users, controllers: { omniauth_callbacks: 'omniauth_callbacks' }
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  resources :messages do
    patch 'talk', on: :member
  end

  resources :orders
  resources :companies
  
  resources :users  do
    patch 'make_friend', on: :member
  end

  mount ActionCable.server => '/cable'
end

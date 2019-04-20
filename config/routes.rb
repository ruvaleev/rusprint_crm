Rails.application.routes.draw do
  devise_for :users, controllers: { omniauth_callbacks: 'omniauth_callbacks' }
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  root to: 'orders#index'

  resources :messages do
    patch 'talk', on: :member
  end

  resources :orders do
    put 'update_customer', on: :member
  end

  resources :printers
  get 'get_models', to: 'printers#get_models'

  resources :companies do
    get 'get_printers', on: :member
  end

  resources :prices
  resources :other_order_items

  resources :shopping_carts do
    post 'clear', on: :member
  end
  delete 'shopping_carts', to: 'shopping_carts#destroy'

  resources :users do
    patch 'make_friend', on: :member
  end

  resources :order_items

  mount ActionCable.server => '/cable'
end

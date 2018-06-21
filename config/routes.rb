Rails.application.routes.draw do
  devise_for :users, controllers: { omniauth_callbacks: 'omniauth_callbacks' }
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  resources :questions, shallow: true do
    patch 'create_vote', on: :member

    resources :answers do
      patch 'award', on: :member
      patch 'create_vote', on: :member
      
      resources :comments
    end

  end

  resources :attachments

  resources :messages do
    patch 'talk', on: :member
  end

  resources :users do
    get 'set_email', on: :member
    patch 'set_email', on: :member
  end

  root to: "messages#show"

  mount ActionCable.server => '/cable'
end

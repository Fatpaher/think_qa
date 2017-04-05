Rails.application.routes.draw do
  use_doorkeeper
  devise_for :users, controllers: { omniauth_callbacks: 'omniauth_callbacks'}

  devise_scope :user do
    post :update_user, to: 'omniauth_callbacks#update_user'
  end

  concern :votable do
    member do
      post :vote
      delete :destroy_vote
    end
  end

  resources :questions, only: [:index, :show, :new, :create, :update, :destroy], concerns: :votable do
    resources :answers, only: [:create, :update, :destroy], shallow: true, concerns: :votable do
      patch :select_best, on: :member
    end
  end
  resources :attachments, only: [:destroy]
  resources :votes, only: [:create]
  resources :comments, only: [:create]

  namespace :api do
    namespace :v1 do
      resources :profiles, only: [:index] do
        get :me, on: :collection
      end
      resources :questions, only: [:index, :show, :create] do
        resources :answers, only: [:index, :show, :create], shallow: true
      end
    end
  end

  root to: "questions#index"

  mount ActionCable.server => '/cable'
end

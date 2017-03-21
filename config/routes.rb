Rails.application.routes.draw do
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

  root to: "questions#index"

  mount ActionCable.server => '/cable'
end

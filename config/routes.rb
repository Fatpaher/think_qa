Rails.application.routes.draw do
  devise_for :users
  resources :questions, only: [:index, :show, :new, :create, :update, :destroy] do
    resources :answers, only: [:create, :update, :destroy], shallow: true do
      patch :select_best, on: :member
    end
  end
  resources :attachments, only: [:destroy]
  root to: "questions#index"
end

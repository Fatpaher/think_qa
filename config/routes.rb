Rails.application.routes.draw do
  devise_for :users
  resources :questions, only: [:index, :show, :new, :create, :update, :destroy] do
    resources :answers, only: [:create, :update, :destroy]
    resources :right_answers, only: [:update]
  end
  root to: "questions#index"
end

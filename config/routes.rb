Rails.application.routes.draw do
  devise_for :users
  resources :questions, only: [:index, :show, :new, :create, :destroy] do
    resources :answers, only: [:create, :destroy]
  end
  root to: "questions#index"
end

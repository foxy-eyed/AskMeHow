Rails.application.routes.draw do
  devise_for :users
  root 'questions#index'

  resources :questions, except: [:edit, :update, :destroy] do
    resources :answers, only: [:new, :create]
  end
end

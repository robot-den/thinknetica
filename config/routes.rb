Rails.application.routes.draw do
  resources :questions do
    resources :answers, only: [:new, :create, :destroy]
  end
  resources :answers, only: [:edit, :update]
end

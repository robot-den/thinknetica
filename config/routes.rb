Rails.application.routes.draw do
  devise_for :users

  root to: "questions#index"

  resources :questions, except: :edit do
    resources :answers, except: [:index, :show, :edit], shallow: true
  end
end

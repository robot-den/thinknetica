Rails.application.routes.draw do
  devise_for :users

  root to: "questions#index"

  resources :questions, except: :edit do
    resources :answers, only: [:create, :update, :destroy], shallow: true
  end

  resources :attachments, only: :destroy

  patch "/answers/set_as_best/:id", to: 'answers#set_as_best', as: 'set_best_answer'
end

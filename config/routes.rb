Rails.application.routes.draw do
  devise_for :users

  root to: "questions#index"

  resources :questions, except: :edit do
    resources :answers, only: [:create, :update, :destroy], shallow: true
  end

  resources :attachments, only: :destroy

  patch "/answers/set_as_best/:id", to: 'answers#set_as_best', as: 'set_best_answer'

  post "/questions/vote_up", to: 'questions#vote_up'
  post "/questions/vote_down", to: 'questions#vote_down'
  post "/questions/vote_cancel", to: 'questions#vote_cancel'
end

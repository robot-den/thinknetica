Rails.application.routes.draw do
  concern :votable do
    member do
      post :vote_up
      post :vote_down
      post :vote_cancel
    end
  end

  devise_for :users

  root to: "questions#index"

  resources :questions, except: :edit, concerns: :votable do
    resources :answers, only: [:create, :update, :destroy], shallow: true, concerns: :votable
  end

  resources :attachments, only: :destroy

  patch "/answers/set_as_best/:id", to: 'answers#set_as_best', as: 'set_best_answer'

  # post "/questions/vote_up", to: 'questions#vote_up'
  # post "/questions/vote_down", to: 'questions#vote_down'
  # post "/questions/vote_cancel", to: 'questions#vote_cancel'
  #
  # post "/answers/vote_up", to: 'answers#vote_up'
  # post "/answers/vote_down", to: 'answers#vote_down'
  # post "/answers/vote_cancel", to: 'answers#vote_cancel'


end

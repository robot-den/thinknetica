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
    resources :answers, only: [:create, :update, :destroy], shallow: true, concerns: :votable do
      resources :comments, only: [:create]
    end
    resources :comments, only: [:create]
  end

  resources :attachments, only: :destroy

  patch "/answers/set_as_best/:id", to: 'answers#set_as_best', as: 'set_best_answer'
end

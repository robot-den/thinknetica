Rails.application.routes.draw do
  concern :votable do
    member do
      post :vote_up
      post :vote_down
      post :vote_cancel
    end
  end

  concern :commentable do
    member do
      post :create_comment
    end
  end

  devise_for :users

  root to: "questions#index"

  resources :questions, except: :edit, concerns: [:votable, :commentable] do
    resources :answers, only: [:create, :update, :destroy], shallow: true, concerns: [:votable, :commentable]
  end

  resources :attachments, only: :destroy

  patch "/answers/set_as_best/:id", to: 'answers#set_as_best', as: 'set_best_answer'
end

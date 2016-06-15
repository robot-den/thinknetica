Rails.application.routes.draw do
  use_doorkeeper

  concern :votable do
    member do
      post :vote_up
      post :vote_down
      post :vote_cancel
    end
  end

  devise_for :users, controllers: { omniauth_callbacks: 'omniauth_callbacks' }

  root to: "questions#index"

  resources :questions, except: :edit, concerns: :votable do
    resources :answers, only: [:create, :update, :destroy], shallow: true, concerns: :votable do
      member do
        resources :comments, only: [:create], defaults: {commentable: 'answers'}
      end
    end
    member do
      resources :comments, only: [:create], defaults: {commentable: 'questions'}
    end
  end

  resources :attachments, only: :destroy

  patch "/answers/set_as_best/:id", to: 'answers#set_as_best', as: 'set_best_answer'

  get "/omniauth_services/new_email_for_oauth", as: 'new_email_for_oauth'
  post "/omniauth_services/save_email_for_oauth", as: 'save_email_for_oauth'
  get "/omniauth_services/confirm_email", as: 'confirm_email'

  namespace :api do
    namespace :v1 do
      resources :profiles, only: [] do
        get :me, on: :collection
        get :all, on: :collection
      end
      resources :questions, only: [:index, :show] do
        get '/answers', to: 'questions#answers', on: :member
      end
      resources :answers, only: :show
    end
  end
end

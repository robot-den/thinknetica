Rails.application.routes.draw do
  resources :questions do
    resources :answers, only: [:new, :create, :destroy]
  end
  resources :answers, only: [:edit, :update]

  #  Это работает, но создает лишние index и show пути,
  #   а также придется для destroy как-то передавать question_id,
  #   чтобы редиректить на вопрос
  # resources :questions do
  #   resources :answers, shallow: true
  # end
end

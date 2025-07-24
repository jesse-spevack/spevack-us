Rails.application.routes.draw do
  get "up" => "rails/health#show", as: :rails_health_check

  root "tasks#index"

  resources :tasks, only: [ :index ] do
    resources :task_completions, only: [ :create, :destroy ]
  end

  resource :session, only: [ :new, :create, :destroy ]

  # Future phases
  # get "weekly_review/:child_id", to: "reviews#weekly", as: :weekly_review
end

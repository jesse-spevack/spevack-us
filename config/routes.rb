Rails.application.routes.draw do
  get "up" => "rails/health#show", as: :rails_health_check

  root "tasks#daily"

  resources :tasks, only: [] do
    member do
      post :toggle
    end
  end

  get "daily(/:date)", to: "tasks#daily", as: :daily_tasks

  # Future phases
  # resources :children, only: [:index]
  # get "weekly_review/:child_id", to: "reviews#weekly", as: :weekly_review
end

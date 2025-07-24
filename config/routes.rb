Rails.application.routes.draw do
  get "up" => "rails/health#show", as: :rails_health_check

  root "children#index"

  resources :tasks, only: [ :index ] do
    resources :task_completions, only: [ :create, :destroy ]
  end

  resources :children, only: [ :index ] do
    member do
      post :select, as: :select
    end
  end

  # Future phases
  # get "weekly_review/:child_id", to: "reviews#weekly", as: :weekly_review
end

Rails.application.routes.draw do
  devise_for :users
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
  root "projects#index"

  resources :users do
    get 'tasks', to: 'users#tasks', as: 'tasks'
    get 'projects', to: 'users#projects', as: 'projects'
  end

  resources :projects do
    resources :work_tasks
  end
end

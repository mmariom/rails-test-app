Rails.application.routes.draw do
  # get 'reviews/create'
  # get 'movies/index'
  # get 'movies/show'
  # get 'movies/new'
  # get 'movies/create'

  devise_for :users, path: '', path_names: {
    sign_in: 'login',     # URL for login
    sign_out: 'logout',   # URL for logout
    sign_up: 'register',  # URL for registration
    password: 'forget'    # URL for forgot password
  },
  controllers: {
   sessions: 'users/sessions',
   registrations: 'users/registrations',
   passwords: 'users/passwords'  

  }
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  
  resources :movies, only: [:index, :show, :new, :create] do
    resources :reviews, only: [:create, :destroy]
  end

  root 'movies#index'
end

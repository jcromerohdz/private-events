Rails.application.routes.draw do
  get 'static_pages/home'
  get 'static_pages/about'
  resources :users, only: [:new, :create, :show]
  get  '/signup',  to: 'users#new'
  resources :sessions, only: [:new, :create, :destroy]
  get    '/signin',   to: 'sessions#new'
  post   '/signin',   to: 'sessions#create'
  delete '/signout',  to: 'sessions#destroy'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end

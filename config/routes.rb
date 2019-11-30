Rails.application.routes.draw do
  root 'static_pages#home'
  get 'static_pages/home'
  get    '/about',   to: 'static_pages#about'
  resources :users, only: [:new, :create, :show, :index]
  get  '/signup',  to: 'users#new'
  resources :sessions, only: [:new, :create, :destroy]
  get    '/signin',   to: 'sessions#new'
  post   '/signin',   to: 'sessions#create'
  delete '/signout',  to: 'sessions#destroy'
  resources :events, only: [:new, :create, :show, :index]
  get     '/events/new',   to: 'events#new'
  post    '/events/new',   to: 'events#create'
  get     '/event',        to: 'events#show'
  get     '/events',       to: 'events#show'
  patch   '/attend',       to: 'users#going'
  delete  '/not_attend',   to: 'users#not_going'
end

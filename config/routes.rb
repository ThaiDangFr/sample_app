Rails.application.routes.draw do
    resources :users do
        member do
            get :following, :followers
        end
    end

    resources :sessions, :only => [:new, :create, :destroy]
    resources :microposts, :only => [:create, :destroy]
    resources :relationships, :only => [:create, :destroy]

    match '/signup', to: 'users#new', via: [:get]
    match '/signin',  to: 'sessions#new', via: [:get]
    match '/signout', to: 'sessions#destroy', via: [:get, :delete]
    match '/contact', to: 'pages#contact', via: [:get]
    match '/about', to: 'pages#about', via: [:get]
    match '/help', to: 'pages#help', via: [:get]
    root :to => 'pages#home'

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end

Rails.application.routes.draw do
#  get 'sessions/new'

  resources :users
	resources :sessions, :only => [:new, :create, :destroy]

	match '/signup', to: 'users#new', via: [:get]
	match '/signin',  to: 'sessions#new', via: [:get]
	match '/signout', to: 'sessions#destroy', via: [:get, :delete]

#trouve le /contact et le route vers l'action contact du controleur pages

match '/contact', to: 'pages#contact', via: [:get]
match '/about', to: 'pages#about', via: [:get]
match '/help', to: 'pages#help', via: [:get]
root :to => 'pages#home'


#  get 'pages/home'

#  get 'pages/contact'

#  get 'pages/about'

#  get 'pages/help'

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end

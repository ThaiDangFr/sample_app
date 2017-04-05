Rails.application.routes.draw do

  get 'users/new'
match '/signup', to: 'users#new', via: [:get]

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

Beacon::Application.routes.draw do

  root to: 'home#index'
  get '/auth/:provider/callback', to: 'home#login'
  get '/auth/failure', to: 'home#failed_login'
  get '/auth/logout', to: 'home#logout'

  resources :pages
  get '*path', to: 'home#read', as: :read

end

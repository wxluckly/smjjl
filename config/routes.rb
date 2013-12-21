require 'sidekiq/web'
Smjjl::Application.routes.draw do
  mount Sidekiq::Web => '/sidekiq'
  root 'index#index'
  
  resources :products
end

require 'sidekiq/web'
Smjjl::Application.routes.draw do
  mount Sidekiq::Web => '/sidekiq'
  root 'index#index'
  
  resources :products
  resources :sitemap, only: :index
  namespace :ajax do
    get "get_prices"
  end
end

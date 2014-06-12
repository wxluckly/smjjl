require 'sidekiq/web'
Smjjl::Application.routes.draw do
  mount Sidekiq::Web => '/sidekiq'
  root 'index#index'
  
  get "/bargains_categories/:category_id", to: 'bargains_categories#index'
  resources :products
  resources :sitemap, only: :index
  resources :ordered_bargains, only: :index
  namespace :ajax do
    get "get_prices"
    get "get_info"
  end
end

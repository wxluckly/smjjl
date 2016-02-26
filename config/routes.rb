require 'sidekiq/web'
Smjjl::Application.routes.draw do
  mount Sidekiq::Web => '/sidekiq'
  mount GrapeSwaggerRails::Engine => '/api_doc'
  mount Wap::Api => '/'

  root 'index#index'

  get 'test', to: 'index#test'
  get "/bargains_categories/:category_id", to: 'bargains_categories#index'

  resource :auth
  resource :wechat, only: [:show, :create]
  resources :products
  resources :sitemap, only: :index
  resources :ordered_bargains, only: :index

  namespace :ajax do
    get "get_prices"
    get "get_info"
  end

  namespace :admin do
    root 'welcome#index'
    resources :product_lists do
      put :block, :unblock
    end
  end
end

require 'sidekiq/web'
Smjjl::Application.routes.draw do
  mount Sidekiq::Web => '/sidekiq'
  mount GrapeSwaggerRails::Engine => '/api_doc'
  mount Wap::Api => '/'

  root 'index#index'

  devise_for :users, controllers: { sessions: "users/sessions", registrations: "users/registrations", passwords: "users/passwords" }

  get 'test', to: 'index#test'
  get "/bargains_categories/:category_id", to: 'bargains_categories#index'

  resource :auth
  resource :wechat, only: [:show, :create]
  resources :products
  resources :sitemap, only: :index
  resources :ordered_bargains, only: :index

  namespace :users do
    get 'ucenter', to: 'invites#index'
    resources :invites
  end

  namespace :ajax do
    get "get_prices"
    get "get_info"
  end

  namespace :admin do
    root 'welcome#index'
    resources :product_lists do
      member do
        put :block, :unblock
      end
      collection do
        post :set_is_prior
      end
    end
  end
end

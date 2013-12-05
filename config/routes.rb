require 'sidekiq/web'

Smjjl::Application.routes.draw do
  root 'index#index'

  mount Sidekiq::Web => '/sidekiq'
end

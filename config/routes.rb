require 'sidekiq/web'
require 'sidetiq/web'

Smjjl::Application.routes.draw do
  root 'index#index'

  mount Sidekiq::Web => '/sidekiq'
end

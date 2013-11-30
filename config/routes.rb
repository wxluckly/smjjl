Smjjl::Application.routes.draw do
  root 'index#index'

  mount Resque::Server.new, :at => "/resque"
end

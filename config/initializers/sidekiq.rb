Sidekiq.configure_server do |config|
  config.redis = { :url => $config.redis }
end

Sidekiq.configure_client do |config|
  config.redis = { :url => $config.redis }
end
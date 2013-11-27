require 'resque'

# 指定redis服务器
Resque.redis = Redis.new($config.redis)

Redis::Objects.redis = Redis.new($config.redis)

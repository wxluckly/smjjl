# 全局配置
$config = Setting::Config

$redis = Redis.new($config.redis)

# I18n.enforce_available_locales will default to true in the future
I18n.enforce_available_locales = false

$debug_log = Logger.new("log/debug.log")
$crawler_log = Logger.new("log/crawler.log")
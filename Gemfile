# source 'https://rubygems.org'
source 'http://ruby.taobao.org'

ruby '2.0.0'

# 基础包
gem 'rails', "~> 4.0.0"
gem 'mysql2'
gem 'protected_attributes'
gem 'yajl-ruby'
gem 'sinatra', '>= 1.3.0', :require => nil
gem 'uglifier'
gem 'sass-rails'
gem 'therubyracer'

# 资源模板引擎
gem 'jquery-rails', '2.2.1'
gem 'jquery-ui-rails'
gem 'bootstrap-sass', '~> 2.3'
gem 'will_paginate-bootstrap', '~> 0.2.5'
gem 'lazy_high_charts'

# 异步和定时任务
gem 'sidekiq'
gem 'whenever'

# HTML解析
gem 'typhoeus'
gem 'nokogiri'

# 辅助工具
gem 'quiet_assets'  # 禁用assets log
gem 'will_paginate'
gem 'default_value_for', "~> 3.0.0"
gem 'friendly_id', '~> 5.0.2'
gem 'settingslogic'
gem 'similar_text'
gem 'newrelic_rpm'

group :development, :worker do
  gem 'pry'
  gem "better_errors"
  gem "binding_of_caller"
end

group :development, :test do
  gem "rspec-rails", "~> 2.14.0"
  gem "factory_girl_rails", "~> 4.2.1"
end

group :test do
  gem "faker", "~> 1.1.2"
  gem "capybara", "~> 2.1.0"
  gem "database_cleaner", "~> 1.0.1"
  gem "launchy", "~> 2.3.0"
  gem "selenium-webdriver", "~> 2.35.1"
end

group :production do
  gem 'unicorn'
end
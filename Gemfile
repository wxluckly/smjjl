# source 'https://rubygems.org'
source 'http://ruby.taobao.org'

ruby '2.0.0'

# 基础包
gem 'rails', "~> 4.0.0" #防止mime-type升级到2,导致rails版本下降至0.9
gem 'protected_attributes'
gem 'yajl-ruby'
gem 'sinatra', '>= 1.3.0', :require => nil

# 数据库
gem 'mysql2'

# 资源模板引擎
gem 'sass-rails'
gem 'uglifier'
gem 'jquery-rails', '2.2.1'
gem 'jquery-ui-rails'
gem 'bootstrap-sass', '~> 2.3'
gem 'will_paginate-bootstrap', '~> 0.2.5'
gem "animate-rails"
gem 'execjs'
gem 'therubyracer'

# 异步和定时任务
gem 'sidekiq'
gem 'whenever'

# HTML解析
gem 'typhoeus'
gem 'hpricot'
gem 'nokogiri'

# 文件和图片处理
gem 'mini_magick'
gem 'carrierwave'

# 辅助工具
gem 'quiet_assets'  # 禁用assets log
gem 'will_paginate'
gem 'symbolize'
gem 'default_value_for', "~> 3.0.0"
gem 'friendly_id', '~> 5.0.2'
gem 'lazy_high_charts'
gem 'settingslogic'

group :development, :worker do
  gem 'pry-rails'
  gem 'pry-nav'
  gem 'better_errors'
end

gem 'unicorn'
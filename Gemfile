# source 'https://rubygems.org'
source 'http://ruby.taobao.org'

ruby '2.0.0'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', "~> 4.0.0" #防止mime-type升级到2,导致rails版本下降至0.9

# 数据库
gem 'mysql2'

# 资源模板引擎
gem 'sass-rails'
gem 'uglifier'
gem 'coffee-rails'
gem 'jquery-rails', '2.2.1'
gem 'jquery-ui-rails'
gem 'turbolinks'
gem 'font-awesome-sass'
gem 'anjlab-bootstrap-rails', '3.0.0.0', :require => 'bootstrap-rails' # 根据前端需求，锁定到bootstrap 3.0官方发布版本
gem "animate-rails"

gem 'execjs'
gem 'therubyracer'

# 基础组件
gem 'eventmachine'

# 缓存系统
gem 'redis-activesupport'
gem 'redis-objects'
gem 'cells'

# 异步和定时任务
gem 'resque'
gem 'resque-scheduler', :require=>"resque_scheduler"

# API
gem 'jbuilder'
gem 'yajl-ruby'

# HTML解析
gem 'typhoeus'
gem 'hpricot'
gem 'nokogiri'
gem 'mechanize'

# 权限验证
gem 'devise'
gem "devise-async"
gem 'omniauth'
gem 'omniauth-weibo-oauth2'
gem 'omniauth-qq-connect'
gem 'omniauth-renren-oauth2'
gem 'cancan'

# 表单和客户端验证
gem 'simple_form', :git => 'git://github.com/plataformatec/simple_form.git'
gem 'simple_captcha', git: "git://github.com/freebird0221/simple-captcha.git"

# 富文本编辑器
gem 'rails_kindeditor'

# 文件和图片处理
gem 'mini_magick'
gem 'carrierwave'

# 辅助工具
gem 'quiet_assets'  # 禁用assets log
gem 'bcrypt-ruby' # Use ActiveModel has_secure_password
gem 'i18n_generators'
gem 'settingslogic'
gem 'will_paginate'
gem 'symbolize'
gem 'default_value_for', :git => 'git://github.com/tsmango/default_value_for.git'
gem 'ruby_regex'
gem 'active_hash', '~> 1.0.2' #1.0.2之后的1.2.0 在belongs_to :xxx, -> {}时发生错误
gem 'chinese_pinyin', '~> 0.4.2'  # 新版本0.5.0，参数进行了变更
gem 'spreadsheet'
gem 'friendly_id', :github => 'FriendlyId/friendly_id'
gem 'state_machine'
gem 'ancestry'
gem 'acts_as_follower'
gem 'acts_as_list'
gem 'typhoeus'

# 搜索查询
gem 'ransack'
gem 'tire'

# rails4 upgrade(wish to remove, need coding work)
gem 'protected_attributes'
gem 'rails-observers'

gem 'unicorn'

# 系统监控
gem 'newrelic_rpm'

group :production do
  gem 'rainbows'
  gem 'bluepill'
end

group :development do
  gem 'capistrano'
  gem 'capistrano-bundler'
  gem 'capistrano-rails'
  gem 'sshkit'
  gem 'pry-rails'
  gem 'pry-nav'
  gem 'binding_of_caller'
#  gem 'better_errors'
end

group :development, :test do
  gem 'rspec-rails'
  gem 'factory_girl_rails'
  gem 'timecop'
end

group :doc do
  # bundle exec rake doc:rails generates the API under doc/api.
  gem 'sdoc', require: false
end

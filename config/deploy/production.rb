set :rvm_type, :user
# set :rvm_ruby_version, '2.2.3'
# set :rvm_custom_path, '/home/railsu/.rvm/gems/ruby-2.2.3'
# set :rvm1_ruby_version, "2.2.3"

set :stage, :production

set :branch, :master
set :rails_env, :production


# 代码发布服务器
role :app, %w(118.190.77.187)

# 网站服务器
role :web, %w(118.190.77.187)

# 后台任务服务器
role :job, %w(118.190.77.187)

# 在数据服务器上运行迁移
role :db,  '118.190.77.187', primary: true
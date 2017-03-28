# config valid only for current version of Capistrano
lock '3.4.0'


set :application, 'smjjl'

set :scm, :git
set :repo_url, 'https://github.com/wxluckly/smjjl.git'

set :deploy_to, '/www/smjjl'

set :format, :pretty
set :log_level, :info
set :pty, true

set :bundle_gemfile, -> { release_path.join('Gemfile') }
set :bundle_dir, -> { shared_path.join('bundle') }
set :bundle_flags, '--no-deployment --quiet'
set :bundle_without, %w{development test}.join(' ')
set :bundle_binstubs, -> { shared_path.join('bin') }
set :bundle_roles, :all

# ssh配置
set :ssh_options, {user: 'www'}

# Default value for :linked_files is []
set :linked_files, fetch(:linked_files, []).push('config/database.yml', 'config/secrets.yml', 'config/settings/config.yml', 'config/wechat.yml')

# Default value for linked_dirs is []
set :linked_dirs, fetch(:linked_dirs, []).push('log', 'tmp/pids', 'tmp/cache', 'tmp/sockets', 'vendor/bundle', 'public/system')

# Default value for default_env is {}
# set :default_env, { path: "/home/railsu/.rvm/gems/ruby-2.2.3/:$PATH" }

# Default value for keep_releases is 5
set :keep_releases, 5


namespace :deploy do
  after :restart, :clear_cache do
    on roles(:web), in: :groups, limit: 3, wait: 10 do
      within current_path do
        execute "/bin/bash --login -c 'god restart smjjl'"
      end
    end
  end

  after  :publishing, :restart
end

namespace :puma do
  task :init do
    on roles(:web), in: :groups, limit: 3, wait: 10 do
      execute "GODPID=`ps -ef |grep bin/god|grep -v grep|awk 'NR==1 {print $2}'` && if [ ! -z $GODPID ]; then kill -TERM $GODPID; fi"
      execute "/bin/bash --login -c 'god -c #{deploy_to}/current/config/god.rb'"
    end
  end

  task :start do
    on roles(:web), in: :groups, limit: 3, wait: 10 do
      execute "/bin/bash --login -c 'god start smjjl'"
    end
  end

  task :stop do
    on roles(:web), in: :groups, limit: 3, wait: 10 do
      execute "/bin/bash --login -c 'god stop smjjl'"
    end
  end

  task :restart do
    on roles(:web), in: :groups, limit: 3, wait: 10 do
      execute "/bin/bash --login -c 'god restart smjjl'"
    end
  end
end

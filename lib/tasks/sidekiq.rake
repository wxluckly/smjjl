namespace :sidekiq do

  desc "stop sidekiq"
  task :stop do
    old_pid = File.expand_path('../../../tmp/pids/sidekiq.pid', __FILE__)
    pid = File.read(old_pid).to_i
    Process.kill("USR1", pid)
    p "sidekiq worker stoping"
    sleep 10
    Process.kill("TERM", pid)
    p "sidekiq worker stoped"
    exec "ps aux | grep sidekiq| grep stopping| awk '{print $2}'| xargs kill -9"
  end

  desc "start sidekiq"
  task :start do
    p "sidekiq worker starting"
    exec 'bundle exec sidekiq  -C config/sidekiq.yml -d -e worker'
  end

  desc "restart sidekiq"
  task :restart do
    Rake::Task["sidekiq:stop"].invoke
    Rake::Task["sidekiq:start"].invoke
  end

end
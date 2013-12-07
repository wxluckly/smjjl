namespace :sidekiq do

  desc "stop sidekiq"
  task :stop do
    old_pid = File.expand_path('../../../tmp/pids/sidekiq.pid', __FILE__)
    Process.kill("USR1", File.read(old_pid).to_i)
    p "sidekiq worker stoping"
    sleep 10
    Process.kill("TERM", File.read(old_pid).to_i)
    p "sidekiq worker stoped"
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
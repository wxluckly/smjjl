namespace :unicorn do

  desc "stop unicorn"
  task :stop do
    begin
      old_pid = File.expand_path('../../../tmp/pids/unicorn.pid', __FILE__)
      Process.kill("QUIT", File.read(old_pid).to_i)
      p "unicorn stoped"
    rescue
      p "no unicorn"
    end
  end

  desc "start unicorn"
  task :start do
    p "unicorn starting"
    exec 'bundle exec unicorn_rails -D -c config/unicorn.rb -E production'
  end

  desc "restart unicorn"
  task :restart do
    Rake::Task["unicorn:stop"].invoke
    Rake::Task["unicorn:start"].invoke
  end

end
rails_env = ENV['RAILS_ENV'] || 'production'
rails_root = ENV['RAILS_ROOT'] || "/www/smjjl/current"

God.watch do |w|
  w.name = "smjjl"
  w.interval = 30.seconds # default

  w.env = {"RAILS_ENV"=>rails_env}

  w.start = "cd #{rails_root} && bundle exec puma --config #{rails_root}/config/puma.rb -e #{rails_env} -d"

  w.stop = "kill -TERM `cat #{rails_root}/tmp/pids/puma.pid`"

  w.restart = "kill -USR1 `cat #{rails_root}/tmp/pids/puma.pid`"

  w.start_grace = 10.seconds
  w.restart_grace = 10.seconds
  w.pid_file = "#{rails_root}/tmp/pids/puma.pid"

  w.log = "#{rails_root}/log/god.out.log"
  #
  # w.uid = "#{uid}"
  # w.gid = "#{uid}"
  w.keepalive

  # w.behavior(:clean_pid_file)
  #
  # w.start_if do |start|
  #   start.condition(:process_running) do |c|
  #     c.interval = 5.seconds
  #     c.running = false
  #   end
  # end
  #
  # w.restart_if do |restart|
  #   restart.condition(:memory_usage) do |c|
  #     c.above = 300.megabytes
  #     c.times = [3, 5] # 3 out of 5 intervals
  #   end
  #
  #   restart.condition(:cpu_usage) do |c|
  #     c.above = 50.percent
  #     c.times = 5
  #   end
  # end
  # # lifecycle
  # w.lifecycle do |on|
  #   on.condition(:flapping) do |c|
  #     c.to_state = [:start, :restart]
  #     c.times = 5
  #     c.within = 5.minute
  #     c.transition = :unmonitored
  #     c.retry_in = 10.minutes
  #     c.retry_times = 5
  #     c.retry_within = 2.hours
  #   end
  # end
end

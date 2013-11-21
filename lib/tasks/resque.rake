require 'resque/tasks'
require 'resque_scheduler/tasks'

# 使rake resque能找到相应的类
task "resque:setup" => :environment do
  $LOAD_PATH.unshift "#{Rails.root}/app/models", "#{Rails.root}/app/workers"
end

namespace :resque do
  task :setup do
    require 'resque'
    require 'resque_scheduler'
    require 'resque/scheduler'
    
    # If you want to be able to dynamically change the schedule,
    # uncomment this line.  A dynamic schedule can be updated via the
    # Resque::Scheduler.set_schedule (and remove_schedule) methods.
    # When dynamic is set to true, the scheduler process looks for
    # schedule changes and applies them on the fly.
    # Note: This feature is only available in >=2.0.0.
    # Resque::Scheduler.dynamic = true

    # The schedule doesn't need to be stored in a YAML, it just needs to
    # be a hash.  YAML is usually the easiest.
    Resque.schedule = YAML.load_file("#{Rails.root}/config/schedule.yml")

    # If your schedule already has +queue+ set for each job, you don't
    # need to require your jobs.  This can be an advantage since it's
    # less code that resque-scheduler needs to know about. But in a small
    # project, it's usually easier to just include you job classes here.
    # So, someting like this:
    # require 'jobs'

    # 设置任务执行超时
    Resque::Timeout.timeout = 7200

    Resque.after_fork do |job|
      Resque.redis.client.reconnect
      Redis::Objects.redis.client.reconnect
    end
  end
end

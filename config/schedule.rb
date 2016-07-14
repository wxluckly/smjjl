env :PATH, ENV['PATH']
set :output, "log/cron_log.log"
set :job_template, "bash -l -c ':job'"

# ------------------------ master ------------------------

# 清理旧的优惠信息
every :day, :at => '1:00am', :roles => [:master] do
  rake "daemon:clear_bargains"
end

# 抓取id
every :day, :at => '2:00am', :roles => [:master] do
  rake "daemon:get_id"
end

# 更新内容
every :day, :at => '3:00am', :roles => [:master] do
  rake "daemon:update_info"
end

# 更新内容
every :day, :at => '5:00am', :roles => [:master] do
  rake "daemon:update_content"
end

# 清理失败的任务
every '59 6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23 * * *', :roles => [:master] do
  rake "daemon:clear_jobs"
end

# 抓取价格
every '0 0,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23 * * *', :roles => [:master] do
  rake "daemon:update_price"
end

# 每小时清空log
every '0 * * * *', :roles => [:master] do
  command "cd /www/smjjl && > log/production.log"
end

# 每3分钟检查队列
every '*/3 * * * *', :roles => [:master] do
  rake "daemon:check_jobs"
end

# 更换ip
every '58 1,3,5,7,9,11,13,15,17,19,21,23 * * *', :roles => [:master] do
  rake "daemon:change_eips"
end

# ------------------------ worker ------------------------

# 重启worker服务
every '59 * * * *', :roles => [:worker] do
  rake "sidekiq:restart"
end
class MailerSystem < ActionMailer::Base
  default from: 'thinkgrand_poster@163.com'

  def crawler_notify
    emails = ["44289889@qq.com", "626382735@qq.com"]
    mail(to: emails, subject: '【什么降价了】爬虫通知')
  end

end
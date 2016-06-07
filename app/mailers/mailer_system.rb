class MailerSystem < ActionMailer::Base
  default from: 'thinkgrand_poster@163.com'

  def crawler_notify
    email = "44289889@qq.com"
    mail(to: email, subject: '【什么降价了】爬虫通知')
  end

end
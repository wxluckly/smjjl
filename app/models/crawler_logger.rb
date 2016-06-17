class CrawlerLogger

  def self.login_jd
    page = Nokogiri::HTML(http_get('https://passport.jd.com/uc/login'))

    agent = Mechanize.new
    login_page = agent.get('https://passport.jd.com/uc/login')
    login_form = login_page.forms.first
    login_form.loginname = "wxluckly@gmail.com"
    login_form.loginpwd = "myruby100"
    login_form.nloginpwd = "myruby100"
    login_form.uuid = page.search('#formlogin #uuid').first.attr('value')
    login_form.machineNet = page.search('#formlogin #machineNet').first.attr('value')
    login_form.machineCpu = page.search('#formlogin #machineCpu').first.attr('value')
    login_form.machineDisk = page.search('#formlogin #machineDisk').first.attr('value')
    login_form.eid = '4fbca4ffaacf4fd78d874e36cec83d0524161740'
    login_form.fp = '2c037c35f12540df4408d469550a8937'
    login_form._t = '_ntqpQiF' #page.search('#formlogin #token').first.attr('value')
    # login_form.FWNBPneOXu = page.search('#formlogin [name=FWNBPneOXu]').first.attr('value')




    p login_form

    agent.submit(login_form)
  end

end
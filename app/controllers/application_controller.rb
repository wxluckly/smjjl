class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  helper_method :remove_line_break, :wechat?

  def remove_line_break str
    str.to_s.gsub(/[\r\n\t]/, " ").gsub(/\s+/, " ")
  end

  def wechat?
    request.user_agent =~ /MicroMessenger/
  end

  private
  def wx_auth!
    return if session[:wx_openid]
    session[:back_url] = request.url
    $debug_log.error("尝试获取session[:wx_openid]为(#{session[:wx_openid]})用户的wx_user")
    if session[:wx_openid].blank?
      back_url = URI.escape("http://#{$config.wechat.back_domain}/auth?back_url=#{request.url}")
      url = URI::HTTPS.build([nil, "open.weixin.qq.com", nil, "/connect/oauth2/authorize", {appid: $config.wechat.appid, redirect_uri: back_url, response_type: 'code', scope: 'snsapi_base', state: ""}.to_param, 'wechat_redirect']).to_s
      redirect_to(url)
    end
  end
end

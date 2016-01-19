class AuthsController < ApplicationController

  # 在微信端验证后，客户端的响应页面
  def show
    if (code = params[:code]).present?
      json_resp = get_access_token(code)
      session[:wx_openid] = json_resp["openid"]
      cookies[:wx_openid] = { value: json_resp["openid"], expires: (json_resp["expires_in"] - 100).seconds.from_now.utc }
      redirect_to (session[:back_url] || params[:back_url])
      session.delete(:back_url)
    else
      render text: '需要授权'
    end
  rescue
    redirect_to (session[:back_url] || params[:back_url])
  end

  private
  def get_access_token(code, flag = 0)
    flag += 1
    resp = RestClient.get("https://api.weixin.qq.com/sns/oauth2/access_token?appid=#{$config.wechat.appid}&secret=#{$config.wechat.secret}&code=#{code}&grant_type=authorization_code")
    json_resp = ActiveSupport::JSON.decode(resp)
    if flag <= 3 && json_resp["access_token"].blank?
      get_access_token(code, flag)
    elsif json_resp["access_token"]
      json_resp
    else
      $debug_log.error("获取access_token错误")
    end
  end
end

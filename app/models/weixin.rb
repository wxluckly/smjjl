class Weixin < ActiveRecord::Base

  #获取token
  def self.token
    token = reload_token unless token = $redis.get('weixin_token')
    return token
  end

  def self.reload_token
    response = Typhoeus::Request.get("https://api.weixin.qq.com/cgi-bin/token?grant_type=client_credential&appid=#{$config.wechat.appid}&secret=#{$config.wechat.secret}", timeout: 2)
    token = JSON.parse(response.body)["access_token"]
    $redis.set('weixin_token', token, expires_in: 3600)
    return token
  end

  # 获取jsapi_ticket
  def self.jsapi_ticket
    jsapi_ticket = reload_jsapi_ticket unless jsapi_ticket = $redis.get('weixin_jsapi_ticket')
    return jsapi_ticket
  end

  def self.reload_jsapi_ticket
    response = Typhoeus::Request.get("https://api.weixin.qq.com/cgi-bin/ticket/getticket?access_token=#{Weixin.token}&type=jsapi", timeout: 2)
    jsapi_ticket = JSON.parse(response.body)["ticket"]
    $redis.set('weixin_jsapi_ticket', jsapi_ticket, expires_in: 3600)
    return jsapi_ticket
  end

  #二维码
  def self.qr_code(scene_id)
    url = "https://api.weixin.qq.com/cgi-bin/qrcode/create?access_token=#{Weixin.token}"
    h = {
      :action_name => 'QR_LIMIT_SCENE',
      :action_info => {
        :scene => {
          :scene_id => scene_id
        }
      }
    }

    result = Typhoeus::Request.post(url, h.to_json)
    response = JSON.parse(result)

    WxQrcodeMongo.create({:scene_id => scene_id, :url => response['url'], :image => "https://mp.weixin.qq.com/cgi-bin/showqrcode?ticket=#{response['ticket']}"})

    return "https://mp.weixin.qq.com/cgi-bin/showqrcode?ticket=#{response['ticket']}"
  end

  #微信上传媒体文件
  def self.upload(path, type="image")
   result = `curl -F media=@#{path} "http://file.api.weixin.qq.com/cgi-bin/media/upload?access_token=#{self.token}&type=#{type}"`
   response = JSON.parse(result)

   return response["media_id"]
  end

  def self.download(media_id, type='amr')
    response = Typhoeus::Request.get("http://file.api.weixin.qq.com/cgi-bin/media/get?access_token=#{self.token}&media_id=#{media_id}")
    path = "tmp/#{Time.now.to_f}.#{type}"

    File.open(path, 'wb') do |f|
      f.write response.body
    end

    return path
  end

  #获取用户openid列表
  def self.list_openid
    open_ids, next_id = [], ""
    next_id, open_ids = self.fetch_openid(open_ids, next_id)
    while next_id.present?
      next_id, open_ids = self.fetch_openid(open_ids, next_id)
    end
    return open_ids
  end

  #获取单次openid，最多10000条，跟list_openid配合
  def self.fetch_openid(ids, next_id)
    url = "https://api.weixin.qq.com/cgi-bin/user/get?access_token=#{self.token}&next_openid=#{next_id}"
    response = Typhoeus::Request.get(url, timeout: 1)
    result = JSON.parse(response.body)
    ids = ids + result["data"]["openid"] if result["data"].present?
    return result["next_openid"], ids
  end

  #发客服消息
  def self.send_msg(openid, content, type)
    body = type == "text" ? {
      touser: openid,
      msgtype: "#{type}",
      text:
      {
        content: content
      }} : content
    response = Typhoeus::Request.post("https://api.weixin.qq.com/cgi-bin/message/custom/send?access_token=#{self.token}", body: body.to_json, timeout: 4)
    result = JSON.parse(response.body)
  end

  def self.send_image(openid, path, type="image")
    media_id = Weixin.upload(path, type)
    body = {
      touser: openid,
      msgtype: "#{type}",
      "#{type}" => {
        media_id: media_id
      }
    }
    p body.to_json
    response = Typhoeus::Request.post("https://api.weixin.qq.com/cgi-bin/message/custom/send?access_token=#{self.token}", body: body.to_json, timeout: 2)
    result = JSON.parse(response.body)
  end

  def self.send_video(openid, media_id, image_media_id, title, description)
    body = {
      touser: openid,
      msgtype: "video",
      "video" => {
        media_id: media_id,
        thumb_media_id: image_media_id,
        title: title,
        description: description
      }
    }
    p body.to_json
    response = Typhoeus::Request.post("https://api.weixin.qq.com/cgi-bin/message/custom/send?access_token=#{self.token}", body: body.to_json, timeout: 2)
    result = JSON.parse(response.body)
  end

  def self.send_template(openid, template_id, data, link=nil)
    body = {
      touser: openid,
      template_id: template_id,
      url: link,
      topcolor: "#FF0000",
      data: data
    }

    p body.to_json
    response = Typhoeus::Request.post("https://api.weixin.qq.com/cgi-bin/message/template/send?access_token=#{self.token}", body: body.to_json, timeout: 2)
    result = JSON.parse(response.body)
  end



  #群发消息
  def self.send_all(type="text", content="测试消息")
    open_ids = self.list_openid

    open_ids.each do |oid|
      self.send_msg(oid, content, type)
    end
  end

  #QRcode
  def self.qr_code(scene_id)
    body = {"action_name" => "QR_LIMIT_SCENE", "action_info" => {"scene" => {"scene_id" => scene_id}}}
    p body.to_json
    response = Typhoeus::Request.post("https://api.weixin.qq.com/cgi-bin/qrcode/create?access_token=#{self.token}", body: body.to_json, timeout: 2)
    result = JSON.parse(response.body)
  end

  def self.valid_signature(params)
    return $cache.hread(:weixin, :msg_ids).try(:include?, params["xml"]["CreateTime"]) || params["signature"] != Digest::SHA1.hexdigest(["#{$config.wechat.token}", params["timestamp"], params["nonce"]].sort.join)
  end

  class Unauthorized < StandardError

  end
end

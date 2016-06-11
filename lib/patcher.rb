module Patcher

  def self.included(base)
    base.class_eval do
      include InstanceMethods
      extend ClassMethods
    end
  end

  module InstanceMethods

    # 模拟人访问（默认使用此种）
    def http_get(url)
      3.times do
        begin
          return Typhoeus.get(url, nosignal: true, followlocation: true, headers: {"User-Agent" => UserAgents.rand()}).body
        rescue Timeout::Error
          next
        rescue Net::HTTPNotFound
          next
        rescue Net::HTTPServiceUnavailable
          next
        rescue Exception => e
          Rails.logger.info e.message
          return nil
        end
      end
      Rails.logger.error "#{Time.now.to_s(:db)} #{url} failure!"
      return nil
    end

    # 模拟人访问
    def http_post(url, body)
      3.times do
        begin
          return Typhoeus.post(url, body: body, nosignal: true, followlocation: true, headers: {"User-Agent" => UserAgents.rand()}).body
        rescue Timeout::Error
          next
        rescue Net::HTTPNotFound
          next
        rescue Net::HTTPServiceUnavailable
          next
        rescue Exception => e
          Rails.logger.info e.message
          return nil
        end
      end
      Rails.logger.error "#{Time.now.to_s(:db)} #{url} failure!"
      return nil
    end

    # 前置解码访问
    def http_open(url)
      3.times do
        begin
          return open(url).read.encode("utf-8")
        rescue Timeout::Error
          next
        rescue Net::HTTPNotFound
          next
        rescue Net::HTTPServiceUnavailable
          next
        rescue Exception => e
          Rails.logger.info e.message
          return nil
        end
      end
      Rails.logger.error "#{Time.now.to_s(:db)} #{url} failure!"
      return nil
    end

  end

  module ClassMethods
    def get_image_name(doc)
      content_type = doc.meta["content-type"]
      houzui = {'image/gif' => 'gif', 'image/png' => 'png', 'image/x-png' => 'png',
        'image/jpg' => 'jpg', 'image/jpeg' => 'jpeg', 'image/pjpeg' => 'jpeg',
        'image/bmp' => 'bmp'}[content_type] || "jpeg"
        "avatar." + houzui
      end
    end

  end

  include Patcher
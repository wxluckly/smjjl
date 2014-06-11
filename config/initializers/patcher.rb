module Patcher

  def self.included(base)
    base.class_eval do
      include InstanceMethods
      extend ClassMethods
    end
  end

  module InstanceMethods

    def http_get(url)
      3.times do
        begin
          return Typhoeus.get(url, nosignal: true, followlocation: true).body
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
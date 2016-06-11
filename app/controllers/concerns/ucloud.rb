module Ucloud
  extend ActiveSupport::Concern
  included do

    def change_eip
      Yajl::Parser.new.parse(describe_eip)['EIPSet'].each do |eip_obj|
        unbind_eip eip_obj["EIPId"]
        sleep 2
        release_eip eip_obj["EIPId"]
        sleep 2
      end
      allocate_eip
      sleep 2
      Yajl::Parser.new.parse(describe_eip)['EIPSet'].each do |eip_obj|
        bind_eip eip_obj["EIPId"]
        sleep 2
      end
    end

    # 获取所有eip的信息
    def describe_eip
      params = {
        'Action' => 'DescribeEIP',
        'Region' => 'cn-north-04'
      }
      do_query params
    end

    # 申请eip
    def allocate_eip
      params = {
        'Action' => 'AllocateEIP',
        'Bandwidth' => 2,
        'PayMode' => 'Traffic',
        'OperatorName' => 'Bgp',
        'ChargeType' => 'Dynamic',
        'Region' => 'cn-north-04'
      }
      do_query params
    end

    # 绑定eip
    def bind_eip eip_id
      params = {
        'Action' => 'BindEIP',
        'Region' => 'cn-north-04',
        'EIPId' => eip_id,
        'ResourceType' => 'uhost',
        'ResourceId' => 'uhost-x3keyq'
      }
      do_query params
    end

    # 解绑eip
    def unbind_eip eip_id
      params = {
        'Action' => 'UnBindEIP',
        'Region' => 'cn-north-04',
        'EIPId' => eip_id,
        'ResourceType' => 'uhost',
        'ResourceId' => 'uhost-x3keyq'
      }
      do_query params
    end

    # 释放eip
    def release_eip eip_id
      params = {
        'Action' => 'ReleaseEIP',
        'Region' => 'cn-north-04',
        'EIPId' => eip_id
      }
      do_query params
    end

    private
    def do_query params
      signature = get_signature params.merge!('PublicKey' => $config.ucloud.public_key)
      http_get("http://api.ucloud.cn/?#{params.to_query}&Signature=#{signature}")
    end

    def get_signature params
      str = params.sort.join
      return Digest::SHA1.hexdigest("#{str}#{$config.ucloud.private_key}").gsub(/\n/, '')
    end

    def get_base64 str
      return Base64.encode64(str).gsub(/\n/, '')
    end
  end
end
require 'uri'

class Redis
  # 高可用的服务器集群初始化
  def initialize_with_string(options)
    if options.is_a?(Hash)
      @servers = [options]
    else
      @servers = options.is_a?(Array) ? options : [options]
      @servers.map! {|s| uri = URI(s); {host: uri.host, port: uri.port, password: uri.password, db: uri.path[1..-1].to_i}} if @servers.first.is_a?(String)
    end
      
    initialize_without_string(@servers.first)
  end
  alias_method_chain :initialize, :string
  
  # 拦截所有命令并在当前连接丢失的情况下切换至在线的主服务器
  def synchronize_with_replica(&blk)
    synchronize_without_replica(&blk)
  rescue CannotConnectError
    connect_master
    synchronize_without_replica(&blk)
  rescue CommandError => e
    connect_master if e.to_s =~ /^READONLY/
    synchronize_without_replica(&blk)
  end
  alias_method_chain :synchronize, :replica
  
  private
  
  # 轮询所有服务器，直至与主服务器建立连接
  def connect_master
    @servers.each do |server|
      @client = Client.new(server)
      begin
        break if @client.reconnect && info['role'] == 'master'
      rescue CannotConnectError
        next
      end
    end
  end
end

class Redis::Store
  def initialize(options = { })
    super
    
    # 传入空参数，避免获取参数错误
    _extend_marshalling({})
    _extend_namespace  ({})
  end
  
  class Factory
    def create
      if @addresses.empty?
        @addresses << {}
      end
    
      # 多IP下强制不使用DistributedStore
      ::Redis::Store.new @addresses
    end
  end
end

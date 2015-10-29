#方便操作类似status, type字典数据, ref: Dasai::Message
class DbItem

  attr_reader :opts, :key_map, :value_map, :label_map, :label_value_map, :value_label_map

  def initialize(opts={})
    @opts = opts
    # eg. {office: 1, follow: 2, ...}
    @key_map = opts.inject({}){|r, (k,v)| r[k] = v[:value]; r}
    # eg. {1: office, 2: follow, ...}
    @value_map = @key_map.invert
    # eg. {office: '官方公告', follow: '关注', ...}
    @label_map = opts.inject({}){|r, (k,v)| r[k] = v[:label]; r}
    # eg. {'官方公告': 1, '关注': 2, ...}
    @label_value_map = opts.inject({}){|r, (k,v)| r[v[:label]] = v[:value]; r}
    # eg. {1: '官方公告', 2: '关注', ...}
    @value_label_map = @label_value_map.invert
  end

  #eg. 1 --> 官方公告
  def label_for(dbvalue)
    label_map[value_map[dbvalue]]
  end

  #eg. 1--> :office
  def key_for(dbvalue)
    value_map[dbvalue]
  end

  def self.t
    items = new(
      office: {label: '官方公告', desc: '官方公告',  value: 1},
      follow: {label: '关注', desc: '被关注',  value: 2},
      listen: {label: '订阅', desc: '资源被订阅',  value: 3},
    )
  end
end

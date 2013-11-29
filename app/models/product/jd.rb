class Product::Jd < Product
  # extends ...................................................................
  # includes ..................................................................
  # security (i.e. attr_accessible) ...........................................
  # relationships .............................................................
  # validations ...............................................................
  # callbacks .................................................................
  # scopes ....................................................................
  # additional config .........................................................
  # class methods .............................................................
  # public instance methods ...................................................
  # 获取商品详情
  def get_content
    page = Nokogiri::HTML(http_get(url), nil, 'gbk')
    update( 
      name: page.css("#name h1").text
      #, price_key: (page.css("#product-intro script").text.scan(/SkuId":(\d+)/).last.first rescue nil)
    )
    get_price
    sleep 0.01
  end

  def get_price
    return if self.price_key.nil?
    page = Nokogiri::HTML(http_get("http://p.3.cn/prices/mgets?skuIds=J_#{self.price_key}"))
    if value = (page.text.scan(/p"\:"([\d\.]+)/).first.first rescue nil)
      update(low_price: value.to_i) if low_price.blank?
      record_bargain value
    end
  end

  def record_bargain value
    return if value.to_i == low_price
    prices.create(value: value)
    return if value.to_i > low_price
    bargains.create(price: value, history_low: low_price)
    update(low_price: value.to_i)
  end

  # protected instance methods ................................................
  # private instance methods ..................................................
end

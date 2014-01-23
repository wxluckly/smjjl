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
    self.name = page.css("#name h1").text
    self.category = page.css(".breadcrumb a").map{ |a| a.text }[0, 3].join(",")
    self.image_url = page.css("#spec-n1 img").attr("src").text rescue nil
    self.save
    record_info page.css("#product-detail-1").to_s
  end

  # 从接口获取价格
  def get_price
    page = Nokogiri::HTML(http_get("http://p.3.cn/prices/mgets?skuIds=J_#{self.url_key}"))
    if value = (Yajl::Parser.new.parse(page.text).first["p"] rescue nil)
      record_price value
    end
  end

  def link
    url
  end

  def purchase_link
    "http://p.yiqifa.com/c?s=5f7cc07d&w=693301&c=254&i=160&l=0&e=&t=#{link}"
  end

  # protected instance methods ................................................
  # private instance methods ..................................................
end

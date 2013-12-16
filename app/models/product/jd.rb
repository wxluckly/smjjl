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
    self.info = page.css("#product-detail-1").to_s
    self.save
    get_price
  end

  # 从详情页获取价格
  def get_price
    page = Nokogiri::HTML(http_get("http://p.3.cn/prices/mgets?skuIds=J_#{self.url_key}"))
    self.count = page.css("#summary-grade").text.scan(%r|\d+|).first
    self.score = page.css(".rate").text.scan(%r|\d+|).first
    if value = (page.text.scan(/p"\:"([\d\.]+)/).first.first rescue nil)
      record_bargain value
    end
  end

  def link
    url
  end
  # protected instance methods ................................................
  # private instance methods ..................................................
  private
  def get_score_and_count
    page = JSON.parse(http_get("http://club.jd.com/ProductPageService.aspx?method=GetCommentSummaryBySkuId&referenceId=#{url_key}&callback=getCommentCount"), nil, 'gbk')

  end
  

end

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
    self.category = page.css(".breadcrumb a").map{ |a| a.text }[0, 3].join(",")
    self.image_url = page.css("#spec-n1 img").attr("src").text rescue nil
    self.has_content = true
    self.save
  end

  # 从接口获取价格(目前只有京东有这个方法，待废弃)
  def get_price
    p "已经不推荐使用此方法"
    page = Nokogiri::HTML(http_get("http://p.3.cn/prices/mgets?skuIds=J_#{self.url_key}"))
    if value = (Yajl::Parser.new.parse(page.text).first["p"] rescue nil)
      record_price value
    end
  end

  def link
    "http:#{url}"
  end

  def purchase_link
    link
  end

  def comment_link
    yiqifa "http://club.jd.com/review/#{url_key}-0-1-0.html"
  end

  def info
    Nokogiri::HTML.parse(http_open(url)).css("#product-detail-1").to_html.gsub("data-lazyload", "src")
  end

  # protected instance methods ................................................
  # private instance methods ..................................................
  private
  def yiqifa link
    "http://p.yiqifa.com/c?s=5f7cc07d&w=693301&c=254&i=160&l=0&e=&t=#{link}"
  end

end

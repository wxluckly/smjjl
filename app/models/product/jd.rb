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
    page = Nokogiri::HTML(http_get(link), nil, 'gbk')
    self.category = page.css(".breadcrumb a").map{ |a| a.text }[0, 3].join(",")
    self.image_url = "http:#{page.css('#spec-n1 img').attr('src').text}" rescue nil
    self.has_content = true
    self.save
    sleep 2
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

  def ziying?
    url_key.to_i < 1000000000
  end

  # protected instance methods ................................................
  # private instance methods ..................................................
  private
  def yiqifa link
    "http://p.yiqifa.com/c?s=5f7cc07d&w=693301&c=254&i=160&l=0&e=&t=#{link}"
  end

end

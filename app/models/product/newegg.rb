class Product::Newegg < Product
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
    page = Nokogiri::HTML(http_get(link), nil, "GBK")
    self.name = page.css(".proHeader h1").text
    (self.category = page.css("#crumb .inner").text.split(" > ")[1, 3].join(",")) rescue nil
    (self.image_url = page.css("#productImgList .picZoom img").attr("src").text) rescue nil
    self.save
  end

  def link
    url
  end

  def purchase_link
    "http://p.yiqifa.com/c?s=d8b0ade3&w=693301&c=280&i=240&l=0&e=&t=#{link}"
  end

  def good_percent
    "#{score.to_f * 20}%"
  end

  def info
    html = open(url).read
    html.encode!("utf-8")
    Nokogiri::HTML.parse(html).css(".goods_detail_info").to_s
  end

  # protected instance methods ................................................
  # private instance methods ..................................................
end

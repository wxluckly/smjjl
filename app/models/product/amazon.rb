class Product::Amazon < Product
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
    page = Nokogiri::HTML(http_get(link))
    self.name = page.css("#btAsinTitle span").text
    self.category = (page.css("div.bucket").last.css("ul li").map{ |li| li.text.gsub(" > ", ",") }.join("|") rescue nil) if page.css("div.bucket").text.index("查找其它相似商品")
    self.info = page.css("#productDescription .content").to_s
    self.count = page.css("#handleBuy .crAvgStars a").last.text rescue 0
    self.score = page.css(".acrRating").text.scan(%r|[\d\.]+|).first
    self.save
    record_price page
  end

  # ==待删除，从详情页获取价格
  # def get_price
  #   page = Nokogiri::HTML(http_get(link))
  #   record_price page
  # end

  def link
    URI::encode(url || "http://www.amazon.cn/#{(name.blank? ? "-" : name ).gsub(" ", "-").gsub("/", "-")}/dp/#{url_key}/ref=")
  end

  # protected instance methods ................................................
  # private instance methods ..................................................
  private
  def record_price page
    if value = page.css(".priceLarge").text.sub(",", "").scan(%r|[\d\.]+|).first
      record_bargain value
    end
  end
end

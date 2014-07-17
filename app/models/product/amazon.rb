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
    (self.category = page.css("div.bucket").last.css("ul li").map{ |li| li.text.gsub(" > ", ",") }.join("|")[0, 255] if page.css("div.bucket").text.index("查找其它相似商品")) rescue nil
    (self.image_url = page.css("#original-main-image").attr("src").text) rescue nil
    self.has_content = true
    self.save
  end

  def link
    URI::encode(url || "http://www.amazon.cn/#{(name.blank? ? "-" : name ).gsub(%r|[\/\s\\\(\)（）]|, "-")}/dp/#{url_key}/ref=")
  end

  def purchase_link
    link
  end

  def comment_link
    
  end

  def good_percent
    "#{score.to_f * 20}%"
  end

  def info
    Nokogiri::HTML(http_get(link)).css("#productDescription .content").to_s
  end

  # protected instance methods ................................................
  # private instance methods ..................................................
end

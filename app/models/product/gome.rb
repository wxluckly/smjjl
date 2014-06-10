class Product::Gome < Product
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
    self.category = (page.css(".local a").map(&:text)[1, 2].join(',') rescue nil)
    self.image_url = (page.css(".j-bpic-b").attr("gome-src").text rescue nil)
    self.score = (Nokogiri::HTML(http_get("http://www.gome.com.cn/ec/homeus/n/product/browse/getProductDetail.jsp?productId=#{url_key.split("-").first}&skuId=#{url_key.split("-").last}")).text.scan(/goodCommentPercent\":\"(\d+)/).first.first rescue nil)
    self.save
    detail_page = (Nokogiri::HTML(http_get(page.css("script")[-4].text.scan(/htmHref:\"(.+?)\"/).first.first))rescue nil)
    if detail_page
      info = detail_page.css("table").to_s
      info = detail_page.css("img").to_s if info.blank?
      record_info info
    end
  end

  def link
    "http://www.gome.com.cn/product/#{url_key}.html"
  end

  def purchase_link
    "http://p.yiqifa.com/c?s=9551994a&w=693301&c=5579&i=14922&l=0&e=&t=#{link}"
  end

  def info
    page = Nokogiri::HTML(http_get(link))
    detail_page = (Nokogiri::HTML(http_get(page.css("script")[-4].text.scan(/htmHref:\"(.+?)\"/).first.first))rescue nil)
    info = detail_page.css("table").to_s
    info = detail_page.css("img").to_s if info.blank?
    info
  end

  # protected instance methods ................................................
  # private instance methods ..................................................
end

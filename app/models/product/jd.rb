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
    if self.category.blank?
      self.category = page.css(".crumb a").map{ |a| a.text }[0, 3].join(",")
    end
    self.image_url = "http:#{page.css('#spec-n1 img').attr('src').text}" rescue nil
    if self.image_url.blank?
      self.image_url = "http:#{page.css('#spec-img').attr('data-origin').text}" rescue nil
    end
    self.name = page.css('#name h1').text
    if self.name.blank?
      self.name = page.css('.sku-name').text rescue nil
    end
    self.has_content = true
    self.save
  end

  def link
    "http:#{url}"
  end

  def m_link
    "http://item.m.jd.com/product/#{url_key}.html"
  end

  def wx_link
    "http://wq.jd.com/item/view?sku=#{url_key}"
  end

  def purchase_link
    "http://p.yiqifa.com/n?k=2mLErntOWZLErI6H2mLErn2s6ZLO1NWlWnBH6EDmrI6HkQLErJPE696w6njFrnj7RKMsCZL-&t=#{link}"
  end

  def m_purchase_link
    "http://p.yiqifa.com/n?k=2mLErntOWZLErI6H2mLErn2s6ZLO1NWlWnBH6EDmrI6HkQLErJPE696w6njFrnj7RKMsCZL-&t=#{m_link}"
  end

  def wx_purchase_link
    "http://p.yiqifa.com/n?k=2mLErntOWZLErI6H2mLErn2s6ZLO1NWlWnBH6EDmrI6HkQLErJPE696w6njFrnj7RKMsCZL-&t=#{wx_link}"
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

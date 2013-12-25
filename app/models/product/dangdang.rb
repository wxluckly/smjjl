class Product::Dangdang < Product
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
    self.name = page.css(".head h1").text
    self.category = page.css(".breadcrumb a").map{ |a| a.text }.join(",")
    self.count = page.css("#comm_num_down i").text
    self.score = page.css("#comm_num_up i").last.text.scan(%r|[\d\.]+|).first rescue nil
    self.save
    record_info page.css("#detail_all").to_s
  end

  def link
    "http://product.dangdang.com/#{url_key}.html"
  end

  def purchase_link
    "http://p.yiqifa.com/c?s=e854bab4&w=693301&c=17307&i=39336&l=0&e=&t=#{link}"
  end

  def good_percent
    "#{score.to_f * 20}%"
  end

  # protected instance methods ................................................
  # private instance methods ..................................................
end

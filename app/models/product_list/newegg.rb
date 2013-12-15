class ProductList::Newegg < ProductList
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
  # 获取分页的初始页
  def get_pagination(category = "id")
    total_page = Nokogiri::HTML(http_get("#{url}?sort=50&pageSize=96"), nil, "GBK").css(".innerb ins").text.scan(%r|/(\d+)|).first.first.to_i rescue 1
    1.upto total_page do |page_num|
      GetIdWorker.perform_async(id, page_num) if category == "id"
      UpdateListPriceWorker.perform_async(id, page_num) if category == "price"
    end
  end

  # 在列表中获取product id
  def get_product_ids(page_num)
    page_url = url.gsub(".htm", "-#{page_num}.htm?sort=50&pageSize=96")
    Nokogiri::HTML(http_get(page_url), nil, "GBK").css(".catepro p.title a").each do |a|
      Product::Newegg.create(url: a.attr("href"))
    end
  end

  # 从列表中更新价格
  def get_list_prices(page_num)
    page_url = url.gsub(".htm", "-#{page_num}.htm?sort=50&pageSize=96")
    Nokogiri::HTML(http_get(page_url), nil, "GBK").css(".catepro li.cls").each do |li|
      next unless li.css("p.title a")
      next unless product = Product::Newegg.where(url: li.css("p.title a").attr("href").to_s.strip).first
      product.record_bargain li.css('.price').text.scan(/[\d\.]+/).join
    end
  end

  # protected instance methods ................................................
  # private instance methods ..................................................
end

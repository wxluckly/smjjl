class ProductList::Dangdang < ProductList
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
  def get_pagination(type = "id")
    total_page = Nokogiri::HTML(http_get("http://category.dangdang.com/#{url_key}.html"), nil, "GBK").css(".page_input span").first.text.scan(%r|\d+|).first.to_i rescue 1
    1.upto total_page do |page_num|
      GetIdWorker.perform_async(id, page_num) if type == "id"
      UpdateListPriceWorker.perform_async(id, page_num) if type == "price"
    end
  end

  # 在列表中获取product id
  def get_product_ids(page_num)
    page_url = "http://category.dangdang.com/pg#{page_num}-#{url_key}.html"
    Nokogiri::HTML(http_get(page_url), nil, "GBK").css(".shoplist p.name a").each do |a|
      Product::Dangdang.create(url: a.attr("href"), url_key: a.attr("href").scan(%r|\d+|).first)
    end
  end

  # 从列表中更新价格
  def get_list_prices(page_num)
    page_url = "http://category.dangdang.com/pg#{page_num}-#{url_key}.html"
    Nokogiri::HTML(http_get(page_url), nil, "GBK").css(".shoplist li").each do |li|
      next unless product = Product::Newegg.where(url_key: li.css("p.name a").first.attr("href").scan(%r|\d+|).first).first
      product.record_bargain li.css('.price_n').text.scan(/[\d\.]+/).join
    end
  end

  # protected instance methods ................................................
  # private instance methods ..................................................
end

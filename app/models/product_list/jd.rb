class ProductList::Jd < ProductList
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
  def get_pagination(category)
    total_page = Nokogiri::HTML(http_get(url)).css(".pagin a")[-2].text.to_i rescue 1
    1.upto total_page do |page_num|
      GetIdWorker.perform_async(id, page_num)
    end
  end

  def get_product_ids(page_num)
    page_url = url.gsub(".html", "-0-0-0-0-0-0-0-1-5-#{page_num}-1-1-72-4137-33.html")
    Nokogiri::HTML(http_get(page_url)).css("#plist .p-name a").map{ |a| a.attr("href") }.each do |puduct_url|
      Product::Jd.create(url: puduct_url, url_key: (puduct_url.scan(/\d+/).first rescue nil) )
    end
  end

  # 从列表中更新价格及其他信息
  def get_list_prices(page_num)
    page_url = url.gsub(".html", "-0-0-0-0-0-0-0-1-5-#{page_num}-1-1-72-4137-33.html")
    Nokogiri::HTML(http_get(page_url), nil, "gbk").css("#plist li").each do |li|
      product = Product::Jd.where(url_key: li.css(".p-name a").attr("href").text.scan(/\d+/)).first rescue nil
      next if product.blank? 
      product.name = li.css(".p-name").text
      product.count = li.css(".evaluate").text.scan(%r|\d+|).first rescue nil
      product.score = li.css(".reputation").text.scan(%r|\d+|).first rescue nil
      product.save
    end
  end

  # protected instance methods ................................................
  # private instance methods ..................................................
end

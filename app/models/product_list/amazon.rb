class ProductList::Amazon < ProductList
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
    total_page = (Nokogiri::HTML(http_get("http://www.amazon.cn/s/ref=?rh=n%3A#{url_key}&page=1&sort=-launch-date")).css("#resultCount").text.gsub(",", "").scan(%r|共(\d+)|).first.first.to_i / 24 + 1) rescue 1
    1.upto total_page do |page_num|
      GetIdWorker.perform_async(id, page_num) if type == "id"
      UpdateListPriceWorker.perform_async(id, page_num) if type == "price"
    end
  end

  # 在列表中获取product id
  def get_product_ids(page_num)
    page_url = "http://www.amazon.cn/s/ref=?rh=n%3A#{url_key}&page=#{page_num}&sort=-launch-date"
    Nokogiri::HTML(http_get(page_url)).css("#rightResultsATF div").each do |div|
      Product::Amazon.create(url_key: div.attr("name")) if div.attr("name")
    end
  end

  # 从列表中更新价格
  def get_list_prices(page_num)
    page_url = "http://www.amazon.cn/s/ref=?rh=n%3A#{url_key}&page=#{page_num}&sort=-launch-date"
    Nokogiri::HTML(http_get(page_url)).css("#rightResultsATF div").each do |div|
      next unless div.attr("name")
      begin
        price = div.css('span').first.text.scan(/[\d\.]+/).join
        product = Product::Amazon.where(url_key: div.attr("name").strip).first
        product.record_bargain price
      rescue
        next
      end
    end
  end

  # protected instance methods ................................................
  # private instance methods ..................................................
end

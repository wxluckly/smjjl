class ProductList::Gome < ProductList
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
  def get_pagination(category = "id")
    binding.pry
    total_page = (Nokogiri::HTML(http_get("http://www.gome.com.cn/category/#{url_key}.html")).css(".num").text.split("/").last) rescue 1
    1.upto total_page do |page_num|
      GetIdWorker.perform_async(id, page_num) if category == "id"
      UpdateListPriceWorker.perform_async(id, page_num) if category == "price"
    end
  end

  def get_product_ids(page_num)
    page_url = "http://www.gome.com.cn/p/json?module=async_search&paramJson=%7B%22pageNumber%22%3A%22#{page_num}%22%2C%22envReq%22%3A%7B%22catId%22%3A%22#{url_key}%22%2C%22pageSize%22%3A36%7D%7D"
    Yajl::Parser.new.parse(Nokogiri::HTML(http_get(page_url)).text)["products"].each do |product|
      Product::Gome.create(url_key: product["pId"]) if product["pId"]
    end
  end

  # 从列表中更新价格及其他信息
  def get_list_prices(page_num)
    page_url = "http://www.gome.com.cn/p/json?module=async_search&paramJson=%7B%22pageNumber%22%3A%22#{page_num}%22%2C%22envReq%22%3A%7B%22catId%22%3A%22#{url_key}%22%2C%22pageSize%22%3A36%7D%7D"
    Yajl::Parser.new.parse(Nokogiri::HTML(http_get(page_url)).text)["products"].each do |elem|
      product = Product::Gome.where(url_key: elem["pId"].strip).first
      next if product.blank?
      product.name = elem["skus"]["name"]
      product.count = elem["evaluateCount"]
      product.save
      product.record_price elem["skus"]["price"]
    end
  end

  # protected instance methods ................................................
  # private instance methods ..................................................
end

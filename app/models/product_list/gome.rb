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
    total_page = (Nokogiri::HTML(http_get("http://www.gome.com.cn/category/#{url_key}.html")).css(".num").text.split("/").last.to_i) rescue 1
    1.upto total_page do |page_num|
      GetIdWorker.perform_async(id, page_num) if category == "id"
      UpdateListPriceWorker.perform_async(id, page_num) if category == "price"
    end
  end

  def get_product_ids(page_num)
    page_url = "http://www.gome.com.cn/p/json?module=async_search&paramJson=%7B%22pageNumber%22%3A%22#{page_num}%22%2C%22envReq%22%3A%7B%22catId%22%3A%22#{url_key}%22%2C%22pageSize%22%3A36%7D%7D"
    Yajl::Parser.new.parse(Nokogiri::HTML(http_get(page_url).gsub("<", "")).text)["products"].each do |elem|
      url_key = "#{elem["pId"].strip}-#{elem["skuId"].strip}"
      Product::Gome.create(url_key: url_key) if url_key
    end
  end

  # 从列表中更新价格及其他信息
  def get_list_prices(page_num)
    page_url = "http://www.gome.com.cn/p/json?module=async_search&paramJson=%7B%22pageNumber%22%3A%22#{page_num}%22%2C%22envReq%22%3A%7B%22catId%22%3A%22#{url_key}%22%2C%22pageSize%22%3A36%7D%7D&_=#{Time.now.to_i}"
    Yajl::Parser.new.parse(Nokogiri::HTML(http_get(page_url)).text)["products"].each do |elem|
      url_key = "#{elem["pId"].strip}-#{elem["skuId"].strip}"
      next unless product = Product::Gome.where(url_key: url_key).first
      name = elem["skus"]["name"].strip rescue nil
      # 如果名称发生巨大变化，则证明原商品已被替换，进行下架处理
      if name and product.name.similar(name) > 85
        product.name = name
        product.count = elem["evaluateCount"]
        product.save
        product.record_price elem["skus"]["price"]
      else
        product.update_columns(url_key: nil, url: nil, is_discontinued: true)
      end
    end
  end

  # protected instance methods ................................................
  # private instance methods ..................................................
  private
  def get_url_key elem
    # 如果子id带有pop字样，则为无效子id，为防止重复抓取，全部予以清除
    # 更新，pop字样，可能是商品的个数不同
    (elem["skuId"].scan("pop").any? || elem["skuId"].scan("N800").any?) ? "#{elem["pId"].strip}" : "#{elem["pId"].strip}-#{elem["skuId"].strip}"
  end

end

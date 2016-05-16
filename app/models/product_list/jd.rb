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
  def list_url
    url
  end

  def get_pagination(category = "id")
    page_url = "#{url}?delivery=1"
    total_page = Nokogiri::HTML(http_get(page_url), nil, Site::Jd::ENCODING).css(".page a")[-3].text.to_i rescue 1
    1.upto total_page do |page_num|
      GetIdWorker.perform_async(id, page_num) if category == "id"
      UpdateListPriceWorker.perform_async(id, page_num) if category == "price"
    end
    return total_page
  end

  def get_product_ids(page_num)
    page_url = "#{url}?delivery=1&page=#{page_num}"
    Nokogiri::HTML(http_get(page_url), nil, Site::Jd::ENCODING).css("#plist .p-name a").map{ |a| a.attr("href") }.each do |puduct_url|
      Product::Jd.create(url: puduct_url, url_key: (puduct_url.scan(/\d+/).first rescue nil) )
    end
    sleep 5
  end

  # 从列表中更新价格及其他信息
  def get_list_prices(page_num)
    page_url = "#{url}?delivery=1&page=#{page_num}"
    page = Nokogiri::HTML(http_get(page_url), nil, Site::Jd::ENCODING)
    key_str = page.css("#plist li .p-name a").map{|a| a.attr("href").scan(/\d+/)}.join(",J_")
    return if key_str.blank?
    value_page = Nokogiri::HTML(http_get("http://p.3.cn/prices/mgets?skuIds=J_#{key_str}&pduid=#{Time.now.to_i}"))
    value_hash = Yajl::Parser.new.parse(value_page.text).inject({}){|hash, v| hash[v["id"]] = v["p"]; hash}
    page.css("#plist li").each do |li|
      product = Product::Jd.where(url_key: li.css(".p-name a").attr("href").text.scan(/\d+/)).first rescue nil
      next if product.blank?
      name = li.css(".p-name").text.strip rescue nil
      if product.name.blank? || (name && product.name.similar(name) > 85)
        product.name = name
        product.count = li.css(".evaluate").text.scan(%r|\d+|).first rescue nil
        product.score = li.css(".reputation").text.scan(%r|\d+|).first rescue nil
        product.save
        product.record_price value_hash["J_#{product.url_key}"]
      else
        # 如果名称发生巨大变化，则证明原商品已被替换，进行下架处理
        product.update_columns(url_key: nil, url: nil, is_discontinued: true)
      end
    end
  end

  # protected instance methods ................................................
  # private instance methods ..................................................
end

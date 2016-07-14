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
  # 处理后的url，根据原有的url进行调整，作为能够跳转的地址
  def list_url
    key = url.match(/\d+-\d+-\d+/)[0]
    "http://list.jd.com/list.html?cat=#{key.split('-').join(',')}"
  end

  def get_pagination(category = "id")
    page_url = "#{list_url}&delivery=1&stock=1"
    total_page = Nokogiri::HTML(http_get(page_url), nil, Site::Jd::ENCODING).css(".page a")[-3].text.to_i rescue 1
    if category == "id"
      1.upto total_page do |page_num|
        GetIdWorker.perform_async(id, page_num)
      end
    elsif category == "price"
      1.upto total_page do |page_num|
        # UpdateListPriceWorker.perform_async(id, page_num)
        UpdateWxListPriceWorker.perform_async(id, page_num)
      end

      1.upto (total_page * 5) do |page_num|
        UpdateMListPriceWorker.perform_async(id, page_num)
      end
    elsif category == "info"
      UpdateListInfoWorker.perform_async(id, page_num)
    end
    return total_page
  end

  def get_product_ids(page_num)
    page_url = "#{list_url}&delivery=1&page=#{page_num}"
    Nokogiri::HTML(http_get(page_url), nil, Site::Jd::ENCODING).css("#plist .p-name a").map{ |a| a.attr("href") }.each do |puduct_url|
      Product::Jd.create(url: puduct_url, url_key: (puduct_url.scan(/\d+/).first rescue nil) )
    end
    sleep 5
  end

  # 从列表中更新产品信息
  def get_list_infos(page_num)
    page_url = "#{list_url}&delivery=1&stock=1&page=#{page_num}"
    page = Nokogiri::HTML(http_get(page_url), nil, Site::Jd::ENCODING)
    key_str = page.css("#plist li .p-name a").map{|a| a.attr("href").scan(/\d+/)}.join(",J_")
    return if key_str.blank?
    page.css("#plist li").each do |li|
      product = Product::Jd.where(url_key: li.css(".p-name a").attr("href").text.scan(/\d+/)).first rescue nil
      next if product.blank?
      name = li.css(".p-name").text.strip rescue nil
      if product.name.blank? || (name && product.name.similar(name) > 85)
        product.name = name
        product.count = li.css(".evaluate").text.scan(%r|\d+|).first rescue nil
        product.score = li.css(".reputation").text.scan(%r|\d+|).first rescue nil
        product.save
      else
        # 如果名称发生巨大变化，则证明原商品已被替换，进行下架处理
        # product.update_columns(url_key: nil, url: nil, is_discontinued: true)
        # 如果名称发生巨大变化，则证明原商品已被替换，直接删除
        product.destroy
      end
    end
  end

  # 从列表中更新价格及其他信息
  def get_list_prices(page_num)
    page_url = "#{list_url}&delivery=1&stock=1&page=#{page_num}"
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
        # product.update_columns(url_key: nil, url: nil, is_discontinued: true)
        # 如果名称发生巨大变化，则证明原商品已被替换，直接删除
        product.destroy
      end
    end
  end

  # 从m站列表中更新价格
  def get_m_list_prices(page_num)
    page_url = "http://so.m.jd.com/ware/searchList.action?_format_=json&stock=1&sort=&self=1&page=#{page_num}&categoryId=#{url.match(/\d+-\d+-\d+/)[0].split('-').last}"
    page = Nokogiri::HTML(http_get(page_url), nil, Site::Jd::ENCODING)
    value_hash = Yajl::Parser.new.parse(page.text)
    value_hash2 = Yajl::Parser.new.parse(value_hash['value'])
    value_hash2['wareList'].each do |obj|
      product = Product::Jd.where(url_key: obj['wareId']).first rescue nil
      next if product.blank?
      product.record_m_price obj['jdPrice']
    end
  end

  # 从微信站列表中更新价格
  def get_wx_list_prices(page_num)
    page_url = "#{list_url}&delivery=1&stock=1&page=#{page_num}"
    page = Nokogiri::HTML(http_get(page_url), nil, Site::Jd::ENCODING)
    key_str = page.css("#plist li .p-name a").map{|a| a.attr("href").scan(/\d+/)}.join(",")
    value_page = "http://pe.3.cn/prices/pcpmgets?origin=5&skuids=#{key_str}"
    page = Nokogiri::HTML(http_get(value_page), nil, Site::Jd::ENCODING)
    value_hash = Yajl::Parser.new.parse(page.text)
    value_hash.each do |obj|
      if product = Product::Jd.find_by(url_key: obj["id"])
        if obj['pcp'].present?
          if obj['p'].to_i > obj['pcp'].to_i
            product.record_price obj['pcp']
          else
            product.record_wx_price obj['p']
          end
        else
          product.record_price obj['p']
        end
      end
    end
  end

  # protected instance methods ................................................
  # private instance methods ..................................................
end

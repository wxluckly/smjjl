namespace :daemon do

  desc "获取新的id"
  task :get_id => :environment do
    ProductRoot.find_each{ |r| r.get_lists }
    ProductList.find_each{ |l| GetPaginationWorker.perform_async(l.id) }
  end

  desc "更新产品内容"
  task :update_content => :environment do
    Product.empty.find_each{|p| UpdateContentWorker.perform_async(p.id) }
  end

  desc "更新产品价格"
  task :update_price => :environment do
    # 京东采取详情页抓取价格的方式：
    Product::Jd.find_each{ |p| UpdatePriceWorker.perform_async(p.id) }
    # 亚马逊采取列表页抓取价格的方式：
    ProductList::Amazon.find_each{ |l| GetPaginationWorker.perform_async(l.id, "price") }
    # 新蛋采取列表页抓取价格的方式：
    ProductList::Newegg.find_each{ |l| GetPaginationWorker.perform_async(l.id, "price") }
    # 当当采取列表页抓取价格的方式：
    ProductList::Dangdang.find_each{ |l| GetPaginationWorker.perform_async(l.id, "price") }
  end

end
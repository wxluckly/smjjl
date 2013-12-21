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
    # 京东从接口更新价格：
    Product::Jd.find_each{ |p| UpdatePriceWorker.perform_async(p.id) }
    # # 京东从列表页抓取信息：
    # ProductList::Jd.find_each{ |l| GetPaginationWorker.perform_async(l.id, "price") }
    # # 亚马逊从列表页抓取价格及信息：
    # ProductList::Amazon.find_each{ |l| GetPaginationWorker.perform_async(l.id, "price") }
    # # 新蛋从列表页抓取价格及信息：
    # ProductList::Newegg.find_each{ |l| GetPaginationWorker.perform_async(l.id, "price") }
    # # 当当从列表页抓取价格及信息：
    # ProductList::Dangdang.find_each{ |l| GetPaginationWorker.perform_async(l.id, "price") }
    
    # 更新所有的列表信息
    ProductList.find_each{ |l| GetPaginationWorker.perform_async(l.id, "price") }
  end

end
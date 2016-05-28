namespace :daemon do

  desc "获取新的id"
  task :get_id => :environment do
    ProductRoot.find_each{ |r| r.get_lists }
    ProductList.unblocked.select(:id).each{ |l| GetPaginationWorker.perform_async(l.id) }
  end

  desc "更新产品内容"
  task :update_content => :environment do
    Product.empty.select(:id).find_each{|p| UpdateContentWorker.perform_async(p.id) }
  end

  desc "更新产品价格"
  task :update_price => :environment do
    ProductList.unblocked.priored.select(:id).each{ |l| GetPaginationWorker.perform_async(l.id, "price") }
  end

end
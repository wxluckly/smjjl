class DaemonPriceWorker
  include Sidekiq::Worker
  include Sidetiq::Schedulable

  # recurrence { daily.hour_of_day(2, 10, 18) }
  recurrence backfill: true do
    daily.hour_of_day(2, 10, 18)
  end

  sidekiq_options :queue => :daemon

  def perform
    # 京东采取详情页抓取价格的方式：
    Product::Jd.find_each do |p|
      UpdatePriceWorker.perform_async(p.id)
    end
    # 亚马逊采取列表页抓取价格的方式：
    ProductList::Amazon.find_each{ |l| GetPaginationWorker.perform_async(l.id, "price") }
  end
end
class DaemonPriceWorker
  include Sidekiq::Worker
  include Sidetiq::Schedulable

  recurrence { daily.hour_of_day(2, 10, 18) }

  @queue = :daemon

  def perform
    Product::Jd.find_each do |p|
      UpdateJdPriceWorker.perform_async(p.id)
    end
  end
end
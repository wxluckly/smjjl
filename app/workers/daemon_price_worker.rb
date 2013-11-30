class DaemonPriceWorker
  include Sidekiq::Worker
  @queue = :daemon

  def perform
    Product::Jd.find_each do |p|
      UpdateJdPriceWorker.perform_async(p.id)
    end
  end
end
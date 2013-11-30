class UpdateJdPriceWorker
  include Sidekiq::Worker
  @queue = :update_jd_price

  def perform(product_id)
    Product::Jd.find(product_id).get_price
  end
end
class UpdateJdPriceWorker
  include Sidekiq::Worker
  @queue = :update_price

  def perform(product_id)
    Product.find(product_id).get_price
  end
end
class UpdatePriceWorker
  include Sidekiq::Worker
  sidekiq_options :queue => :update_price

  def perform(product_id)
    Product.find(product_id).get_price
  end
end
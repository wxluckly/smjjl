class UpdateContentWorker
  include Sidekiq::Worker
  @queue = :update_jd_price

  def perform(product_id)
    Product.find(product_id).get_content
  end
end
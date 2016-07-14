class UpdateContentWorker
  include Sidekiq::Worker
  sidekiq_options :queue => :update_content

  def perform(product_id)
    Product.find(product_id).get_content
    LinksubmitWorker.perform_async(product_id)
  end
end
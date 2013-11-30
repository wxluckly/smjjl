class UpdateJdIdWorker
  include Sidekiq::Worker
  @queue = :update_jd_id

  def perform(product_list_id)
    ProductList::Jd.find(product_list_id).get_product_ids
  end
end
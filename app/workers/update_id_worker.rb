class UpdateIdWorker
  include Sidekiq::Worker
  @queue = :update_id

  def perform(product_list_id)
    ProductList.find(product_list_id).get_product_ids
  end
end
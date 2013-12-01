class GetIdWorker
  include Sidekiq::Worker
  @queue = :update_id

  def perform(product_list_id, page_num)
    ProductList.find(product_list_id).get_product_ids(page_num)
  end
end
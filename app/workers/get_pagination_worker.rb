class GetPaginationWorker
  include Sidekiq::Worker
  sidekiq_options :queue => :get_pagination

  def perform(product_list_id)
    ProductList.find(product_list_id).get_pagination
  end
end
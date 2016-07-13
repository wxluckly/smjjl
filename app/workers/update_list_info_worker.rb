class UpdateListInfoWorker
  include Sidekiq::Worker
  sidekiq_options :queue => :update_list_info

  def perform(product_list_id, page_num)
    ProductList.find(product_list_id).get_list_infos(page_num)
  end
end
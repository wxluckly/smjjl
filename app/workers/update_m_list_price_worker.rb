class UpdateMListPriceWorker
  include Sidekiq::Worker
  sidekiq_options :queue => :update_list_price

  def perform(product_list_id, page_num)
    ProductList.find(product_list_id).get_m_list_prices(page_num)
  end
end
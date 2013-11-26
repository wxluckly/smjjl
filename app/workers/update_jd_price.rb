def UpdateJdPrice
  @queue = :update_jd_price

  def self.perform(product_id)
    Product::Jd.find(product_id).get_price
  end
end
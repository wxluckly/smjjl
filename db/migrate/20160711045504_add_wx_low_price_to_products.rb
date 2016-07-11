class AddWxLowPriceToProducts < ActiveRecord::Migration
  def change
    add_column :products, :wx_low_price, :decimal, precision: 10, scale: 2
    add_column :products, :wx_last_price, :decimal, precision: 10, scale: 2
    add_column :products, :wx_price_history, :text
  end
end

class AddMLowPriceToProducts < ActiveRecord::Migration
  def change
    add_column :products, :m_low_price, :decimal, precision: 10, scale: 2
    add_column :products, :m_last_price, :decimal, precision: 10, scale: 2
    add_column :products, :m_price_history, :text
  end
end

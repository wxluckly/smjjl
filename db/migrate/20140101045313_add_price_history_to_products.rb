class AddPriceHistoryToProducts < ActiveRecord::Migration
  def change
    add_column :products, :price_history, :text
  end
end

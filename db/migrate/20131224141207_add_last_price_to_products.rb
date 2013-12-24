class AddLastPriceToProducts < ActiveRecord::Migration
  def change
    add_column :products, :last_price, :string
  end
end

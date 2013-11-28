class AddColumnLowPriceToProduct < ActiveRecord::Migration
  def change
    add_column :products, :low_price, :integer
  end
end

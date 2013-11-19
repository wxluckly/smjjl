class AddPriceKeyToProduct < ActiveRecord::Migration
  def change
    add_column :products, :price_key, :string
  end
end

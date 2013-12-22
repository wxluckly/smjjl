class RemovePriceKeyFromProducts < ActiveRecord::Migration
  def change
    remove_column :products, :price_key, :string
    remove_column :products, :info, :text
  end
end

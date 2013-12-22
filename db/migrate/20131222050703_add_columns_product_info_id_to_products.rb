class AddColumnsProductInfoIdToProducts < ActiveRecord::Migration
  def change
    add_column :products, :product_info_id, :integer
    add_index :products, :product_info_id
  end
end

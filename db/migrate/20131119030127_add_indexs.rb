class AddIndexs < ActiveRecord::Migration
  def change
    add_index :product_roots, :url
    add_index :product_lists, :url
    add_index :prices, :product_id
  end
end

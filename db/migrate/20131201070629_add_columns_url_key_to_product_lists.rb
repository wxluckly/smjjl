class AddColumnsUrlKeyToProductLists < ActiveRecord::Migration
  def change
    add_column :product_lists, :url_key, :string
    add_index :product_lists, :url_key
  end
end

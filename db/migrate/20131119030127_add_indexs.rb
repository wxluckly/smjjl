class AddIndexs < ActiveRecord::Migration
  def change
    add_index :product_roots, :url
    add_index :product_lists, :url
  end
end

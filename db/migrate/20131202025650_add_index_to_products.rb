class AddIndexToProducts < ActiveRecord::Migration
  def change
    add_index :products, :url
    add_index :products, :url_key
    add_index :products, :name
  end
end

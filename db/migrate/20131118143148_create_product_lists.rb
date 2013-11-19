class CreateProductLists < ActiveRecord::Migration
  def change
    create_table :product_lists do |t|
      t.integer :product_root_id
      t.string  :url
      t.timestamps
    end
  end
end

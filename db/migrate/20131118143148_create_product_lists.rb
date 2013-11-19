class CreateProductLists < ActiveRecord::Migration
  def change
    create_table :product_lists do |t|
      t.string  :type
      t.string  :url
      t.timestamps
    end
  end
end

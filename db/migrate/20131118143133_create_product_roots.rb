class CreateProductRoots < ActiveRecord::Migration
  def change
    create_table :product_roots do |t|
      t.integer :site_id
      t.string  :url
      t.timestamps
    end
  end
end

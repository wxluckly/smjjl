class CreateProductRoots < ActiveRecord::Migration
  def change
    create_table :product_roots do |t|
      t.integer :site_id
      t.string  :list_reg
      t.timestamps
    end
  end
end

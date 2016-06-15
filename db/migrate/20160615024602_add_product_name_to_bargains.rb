class AddProductNameToBargains < ActiveRecord::Migration
  def change
    add_column :bargains, :product_name, :string
    add_index :bargains, :product_name
  end
end

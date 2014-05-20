class AddIndexToProductsColumnIsDiscontinued < ActiveRecord::Migration
  def change
    add_index :products, :is_discontinued
  end
end

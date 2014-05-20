class AddIndexToProductsColumnIsDiscontinued < ActiveRecord::Migration
  def change
    add_index :is_discontinued, :is_discontinued
  end
end

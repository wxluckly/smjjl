class AddIsPriorToProductLists < ActiveRecord::Migration
  def change
    add_column :product_lists, :is_prior, :boolean, default: false
  end
end

class AddIsBlockedToProductLists < ActiveRecord::Migration
  def change
    add_column :product_lists, :is_blocked, :boolean, default: false
  end
end

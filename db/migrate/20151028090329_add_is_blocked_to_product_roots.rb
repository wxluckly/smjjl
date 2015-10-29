class AddIsBlockedToProductRoots < ActiveRecord::Migration
  def change
    add_column :product_roots, :is_blocked, :boolean, default: false
    add_column :products, :is_blocked, :boolean, default: false
  end
end

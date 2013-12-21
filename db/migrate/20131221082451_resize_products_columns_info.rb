class ResizeProductsColumnsInfo < ActiveRecord::Migration
  def change
    change_column :products, :info, :text, limit: 16777215
  end
end

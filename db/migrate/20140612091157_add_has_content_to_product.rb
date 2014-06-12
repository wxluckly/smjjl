class AddHasContentToProduct < ActiveRecord::Migration
  def change
    add_column :products, :has_content, :boolean, default: false
    add_index :products, :has_content
  end
end

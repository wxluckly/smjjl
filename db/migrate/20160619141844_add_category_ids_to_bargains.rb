class AddCategoryIdsToBargains < ActiveRecord::Migration
  def change
    add_column :bargains, :category_ids, :string
    add_index :bargains, :category_ids
  end
end

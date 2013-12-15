class CreateBargainsCategories < ActiveRecord::Migration
  def change
    create_table :bargains_categories do |t|
      t.integer :bargain_id
      t.integer :category_id
      t.timestamps
    end
    add_index :bargains_categories, :bargain_id
    add_index :bargains_categories, :category_id
    add_index :bargains_categories, :created_at
  end
end
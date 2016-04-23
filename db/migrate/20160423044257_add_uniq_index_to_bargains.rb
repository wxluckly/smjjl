class AddUniqIndexToBargains < ActiveRecord::Migration
  def change
    add_index :bargains, [:product_id, :created_at], unique: true
  end
end

class CreateProductInfos < ActiveRecord::Migration
  def change
    create_table :product_infos do |t|
      t.integer :product_id
      t.text :info, limit: 16777215
    end
    add_index :product_infos, :product_id
  end
end

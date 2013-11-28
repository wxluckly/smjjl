class CreateBargains < ActiveRecord::Migration
  def change
    create_table :bargains do |t|
      t.integer :product_id
      t.string  :price
      t.string  :discount
      t.timestamps
    end
  end
end
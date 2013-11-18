class CreatePrices < ActiveRecord::Migration
  def change
    create_table :prices do |t|
      t.string  :product_id
      t.string  :value
      t.timestamps
    end
  end
end

class CreateSeckillProducts < ActiveRecord::Migration
	def change
		create_table :seckill_products do |t|
			t.integer :product_id
			t.decimal :price, precision: 10, scale: 2
			t.decimal :history_low, precision: 10, scale: 2
			t.string :product_name
			t.text :subtitle
			t.timestamps
		end
	end
end

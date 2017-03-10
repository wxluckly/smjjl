class AddSubtitleToProducts < ActiveRecord::Migration
  def change
  	add_column :products, :subtitle, :text
  end
end

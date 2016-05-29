class AddIndexImageUrlOnProducts < ActiveRecord::Migration
  def change
    add_index :products, :image_url
  end
end

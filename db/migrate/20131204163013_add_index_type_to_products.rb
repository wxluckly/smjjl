class AddIndexTypeToProducts < ActiveRecord::Migration
  def change
    add_index :products, :type
  end
end

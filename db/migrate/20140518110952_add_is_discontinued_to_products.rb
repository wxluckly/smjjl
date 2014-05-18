class AddIsDiscontinuedToProducts < ActiveRecord::Migration
  def change
    add_column :products, :is_discontinued, :boolean
  end
end

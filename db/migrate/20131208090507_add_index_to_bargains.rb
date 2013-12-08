class AddIndexToBargains < ActiveRecord::Migration
  def change
    add_index :bargains, :created_at
  end
end

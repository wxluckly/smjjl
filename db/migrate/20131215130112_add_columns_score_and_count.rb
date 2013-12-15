class AddColumnsScoreAndCount < ActiveRecord::Migration
  def change
    add_column :products, :score, :string
    add_column :products, :count, :integer
  end
end

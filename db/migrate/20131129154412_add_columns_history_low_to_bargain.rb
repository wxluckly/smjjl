class AddColumnsHistoryLowToBargain < ActiveRecord::Migration
  def change
    add_column :bargains, :history_low, :integer
  end
end

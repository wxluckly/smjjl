class ChangeBargainHistoryLowType < ActiveRecord::Migration
  def change
    change_column :bargains, :history_low, :string
    change_column :products, :low_price, :string
  end
end

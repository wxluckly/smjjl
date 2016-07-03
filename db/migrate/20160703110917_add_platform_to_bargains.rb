class AddPlatformToBargains < ActiveRecord::Migration
  def change
    add_column :bargains, :platform, :integer
  end
end

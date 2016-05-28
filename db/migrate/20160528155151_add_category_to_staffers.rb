class AddCategoryToStaffers < ActiveRecord::Migration
  def change
    add_column :staffers, :category, :string
  end
end

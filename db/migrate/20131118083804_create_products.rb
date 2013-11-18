class CreateProducts < ActiveRecord::Migration
  def change
    create_table :products do |t|
      t.string  :site_id
      t.string  :name
      t.string  :info
      t.timestamps
    end
  end
end

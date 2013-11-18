class CreateProducts < ActiveRecord::Migration
  def change
    create_table :products do |t|
      t.string  :site_id
      t.string  :name
      t.string  :info
      t.string  :location
      t.timestamps
    end
  end
end

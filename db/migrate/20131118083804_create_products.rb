class CreateProducts < ActiveRecord::Migration
  def change
    create_table :products do |t|
      t.string  :type
      t.string  :name
      t.string  :info
      t.string  :category
      t.string  :url
      t.string  :url_key
      t.timestamps
    end
  end
end

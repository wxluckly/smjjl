class AddWordsToCategory < ActiveRecord::Migration
  def change
    add_column :categories, :words, :text
  end
end

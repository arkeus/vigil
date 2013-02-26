class AddPasteAttributesAndKey < ActiveRecord::Migration
  def up
    change_table :pastes do |t|
      t.string :bucket
      t.integer :width
      t.integer :height
      t.string :content_type
    end
    add_index :pastes, :key, :unique => true, :name => "i_key"
  end
  
  def down
    remove_column :pastes, :bucket
    remove_column :pastes, :width
    remove_column :pastes, :height
    remove_column :pastes, :content_type
    remove_index :pastes, :name => "i_key"
  end
end

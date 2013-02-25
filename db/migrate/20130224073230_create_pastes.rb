class CreatePastes < ActiveRecord::Migration
  def change
    create_table :pastes do |t|
      t.string :filetype, :null => false
      t.string :key
      t.string :name
      t.string :ip, :null => false
      t.string :filename, :null => false
      t.integer :filesize, :null => false
      t.integer :views, :null => false, :default => 0
      t.datetime :expires_at, :null => false
      t.timestamps
    end
  end
end

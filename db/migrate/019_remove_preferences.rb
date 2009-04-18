class RemovePreferences < ActiveRecord::Migration
  def self.up
    drop_table :preferences
  end

  def self.down
    create_table :preferences do |t|
      t.string :key, :null => false
      t.string :value
      t.timestamps
    end
    
    add_index :preferences, :key
  end
end

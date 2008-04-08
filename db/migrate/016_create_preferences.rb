class CreatePreferences < ActiveRecord::Migration
    def self.up
        create_table :preferences do |t|
            t.string :key, :null => false
            t.string :value
            t.timestamps
        end
        
        add_index :preferences, :key
    end

    def self.down
        drop_table :preferences
    end
end

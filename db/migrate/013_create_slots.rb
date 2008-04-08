class CreateSlots < ActiveRecord::Migration
    def self.up
        create_table :slots do |t|
            t.references :raid, :null => false
            t.references :signup
            t.references :role
            t.references :cclass
            t.boolean :closed, :null => false, :default => true
            t.timestamps
        end
        
        add_index :slots, :raid_id
        add_index :slots, :signup_id
        add_index :slots, [:role_id, :cclass_id]
    end

    def self.down
        drop_table :slots
    end
end

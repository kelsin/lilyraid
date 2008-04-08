class CreateSignups < ActiveRecord::Migration
    def self.up
        create_table :signups do |t|
            t.references :raid, :null => false
            t.references :character, :null => false
            t.string :note
            t.timestamps
        end

        add_index :signups, :raid_id
        add_index :signups, :character_id
        add_index :signups, :created_at
        add_index :signups, [:raid_id, :character_id]
    end

    def self.down
        drop_table :signups
    end
end

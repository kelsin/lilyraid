class CreateRaids < ActiveRecord::Migration
    def self.up
        create_table :raids do |t|
            t.string :name
            t.datetime :date, :null => false
            t.integer :min_level
            t.integer :max_level
            t.text :note
            t.text :loot_note
            t.boolean :uses_loot_system, :null => false, :default => false
            t.boolean :locked, :null => false, :default => false
            t.references :instance, :null => false
            t.references :account, :null => false
            t.timestamps
        end

        add_index :raids, :account_id
        add_index :raids, :date
    end

    def self.down
        drop_table :raids
    end
end

class CreateCharacters < ActiveRecord::Migration
    def self.up
        create_table :characters do |t|
            t.references :account, :null => false
            t.references :race, :null => false
            t.references :cclass, :null => false
            t.string :name
            t.string :guild
            t.integer :level
            t.boolean :inactive, :null => false, :default => false
            t.timestamps
        end

        add_index :characters, :account_id
    end

    def self.down
        drop_table :characters
    end
end

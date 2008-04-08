class CreateLoots < ActiveRecord::Migration
    def self.up
        create_table :loots do |t|
            t.references :character, :null => false
            t.references :raid, :null => false
            t.references :list, :null => false
            t.string :item_url
            t.string :item_name
            t.timestamps
        end
        
        add_index :loots, :character_id
        add_index :loots, :raid_id
        add_index :loots, :list_id
    end

    def self.down
        drop_table :loots
    end
end

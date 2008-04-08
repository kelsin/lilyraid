class CreateListPositions < ActiveRecord::Migration
    def self.up
        create_table :list_positions do |t|
            t.references :list, :null => false
            t.references :account, :null => false
            t.integer :position, :null => false
            t.timestamps
        end

        add_index :list_positions, :list_id
        add_index :list_positions, :account_id
        add_index :list_positions, :position
    end

    def self.down
        drop_table :list_positions
    end
end

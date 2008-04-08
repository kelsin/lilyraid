class CreateInstances < ActiveRecord::Migration
    def self.up
        create_table :instances do |t|
            t.string :name
            t.boolean :requires_key, :null => false, :default => false
            t.integer :max_number
            t.integer :min_level
            t.integer :max_level
            t.timestamps
        end
    end

    def self.down
        drop_table :instances
    end
end

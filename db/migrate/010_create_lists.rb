class CreateLists < ActiveRecord::Migration
    def self.up
        create_table :lists do |t|
            t.string :name, :null => false
            t.datetime :date, :null => false
            t.text :note
            t.timestamps
        end

        add_index :lists, :name
        add_index :lists, :date
    end

    def self.down
        drop_table :lists
    end
end

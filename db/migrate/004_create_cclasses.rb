class CreateCclasses < ActiveRecord::Migration
    def self.up
        create_table :cclasses do |t|
            t.string :name
            t.string :color, :limit => 6
            t.timestamps
        end
    end

    def self.down
        drop_table :cclasses
    end
end

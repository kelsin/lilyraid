class CreateAttunements < ActiveRecord::Migration
    def self.up
        create_table :attunements do |t|
            t.references :character
            t.references :instance
            t.timestamps
        end

        add_index :attunements, :character_id
        add_index :attunements, :instance_id
        add_index :attunements, [:character_id, :instance_id]
    end

    def self.down
        drop_table :attunements
    end
end

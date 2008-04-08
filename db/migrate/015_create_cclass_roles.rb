class CreateCclassRoles < ActiveRecord::Migration
    def self.up
        create_table :cclass_roles do |t|
            t.references :cclass
            t.references :role
            t.timestamps
        end

        add_index :cclass_roles, :cclass_id
        add_index :cclass_roles, :role_id
        add_index :cclass_roles, [:cclass_id, :role_id]
    end

    def self.down
        drop_table :cclass_roles
    end
end

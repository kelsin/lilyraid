class CreateSignupRoles < ActiveRecord::Migration
    def self.up
        create_table :signup_roles do |t|
            t.references :signup
            t.references :role
            t.timestamps
        end

        add_index :signup_roles, :signup_id
        add_index :signup_roles, :role_id
        add_index :signup_roles, [:signup_id, :role_id]
    end

    def self.down
        drop_table :signup_roles
    end
end

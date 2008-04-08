class CreateAccounts < ActiveRecord::Migration
    def self.up
        create_table :accounts do |t|
            t.string :name
            t.string :lj_account
            t.integer :age
            t.string :location
            t.string :email
            t.boolean :admin, :null => false, :default => false
            t.text :bio
            t.timestamps
        end
    end

    def self.down
        drop_table :accounts
    end
end

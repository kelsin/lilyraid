class AddRaidFinalFlag < ActiveRecord::Migration
    def self.up
        add_column("raids", "finalized", :boolean, :null => false, :default => false)
    end

    def self.down
        remove_column("raids", "finalized")
    end
end

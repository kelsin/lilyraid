class UniqueIndexOnLocations < ActiveRecord::Migration
  def self.up
    add_index(:locations, [:raid_id, :instance_id],
              :name => "locations_by_raid_and_instance", :unique => true)
  end

  def self.down
    remove_index(:locations, "locations_by_raid_and_instance")
  end
end

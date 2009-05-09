class MoveLootToLocation < ActiveRecord::Migration
  def self.up
    add_column(:loots, 'location_id', :integer)
    
    # Now assign loot location to the raid
    Loot.all.each do |loot|
      loot.location = loot.raid.locations.first
      loot.save
    end

    remove_column(:loots, 'raid_id')
    remove_column(:loots, 'instance_id')
  end

  def self.down
    add_column(:loots, 'raid_id', :integer)
    add_column(:loots, 'instance_id', :integer)

    # Now assign raid and instance again
    Loot.all.each do |loot|
      loot.raid = loot.location.raid
      loot.instance = loot.location.instance
      loot.save
    end

    remove_column(:loots, 'location_id')
  end
end

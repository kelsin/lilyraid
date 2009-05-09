class CreateLocations < ActiveRecord::Migration
  def self.up
    create_table :locations do |t|
      t.references :instance
      t.references :raid
      t.timestamps
    end

    # Now we need to move each raid to a location instead of instance
    Raid.all.each do |raid|
      location = Location.new
      location.raid = raid
      location.instance = raid.instance
      location.save
    end

    remove_column(:raids, 'instance_id')
  end

  def self.down
    add_column(:raids, 'instance_id', :integer)

    # Add instance back in
    Raid.all.each do |raid|
      location = raid.locations.first
      raid.instance = location.instance
      raid.save
    end

    drop_table :locations
  end
end

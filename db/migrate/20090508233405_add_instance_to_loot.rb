class AddInstanceToLoot < ActiveRecord::Migration
  def self.up
    add_column(:loots, 'instance_id', :integer)
  end

  def self.down
    remove_column(:loots, 'instance_id')
  end
end

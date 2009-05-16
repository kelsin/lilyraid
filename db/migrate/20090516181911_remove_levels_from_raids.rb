
class RemoveLevelsFromRaids < ActiveRecord::Migration
  def self.up
    remove_column(:raids, :min_level)
    remove_column(:raids, :max_level)
  end

  def self.down
    add_column(:raids, :min_level, :integer)
    add_column(:raids, :max_level, :integer)
  end
end

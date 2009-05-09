class MakeRaidNameNotNull < ActiveRecord::Migration
  def self.up
    change_column(:raids, 'name', :string, :null => false)
  end

  def self.down
    change_column(:raids, 'name', :string, :null => true)
  end
end

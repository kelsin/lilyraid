class AddInstanceActive < ActiveRecord::Migration
  def self.up
    add_column(:instances, 'active', :boolean, :null => false, :default => true)
  end

  def self.down
    remove_column(:instances, 'active')
  end
end

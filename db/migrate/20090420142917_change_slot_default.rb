class ChangeSlotDefault < ActiveRecord::Migration
  def self.up
    remove_column(:slots, "closed")
  end

  def self.down
    add_column(:slots, "closed", :null => false, :default => true)
  end
end

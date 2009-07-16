class AddPreferedToSignups < ActiveRecord::Migration
  def self.up
    change_table(:signups) do |t|
      t.boolean :preferred, :null => false, :default => false
    end
  end

  def self.down
    change_table(:signups) do |t|
      t.remove :preferred
    end
  end
end

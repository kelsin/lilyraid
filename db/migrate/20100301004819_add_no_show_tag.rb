class AddNoShowTag < ActiveRecord::Migration
  def self.up
    change_table(:signups) do |t|
      t.string :no_show, :null => false, :default => 'Showed Up'
    end
  end

  def self.down
    change_table(:signups) do |t|
      t.remove :no_show
    end
  end
end

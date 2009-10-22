class AddTeamToSlots < ActiveRecord::Migration
  def self.up
    change_table(:slots) do |t|
      t.integer :team
    end
  end

  def self.down
    change_table(:slots) do |t|
      t.remove :team
    end
  end
end

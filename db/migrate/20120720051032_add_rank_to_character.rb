class AddRankToCharacter < ActiveRecord::Migration
  def up
    change_table(:characters) do |t|
      t.integer :rank
    end
  end

  def down
    change_table(:characters) do |t|
      t.remove :rank
    end
  end
end

class AddGuildToRaid < ActiveRecord::Migration
  def up
    change_table(:raids) do |t|
      t.string :guild
    end
  end

  def down
    change_table(:raids) do |t|
      t.remove :guild
    end
  end
end

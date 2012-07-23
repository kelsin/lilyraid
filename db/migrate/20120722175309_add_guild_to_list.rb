class AddGuildToList < ActiveRecord::Migration
  def up
    change_table(:lists) do |t|
      t.string :guild
    end
  end

  def down
    change_table(:lists) do |t|
      t.remove :guild
    end
  end
end

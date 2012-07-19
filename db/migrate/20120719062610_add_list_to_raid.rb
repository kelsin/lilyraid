class AddListToRaid < ActiveRecord::Migration
  def up
    change_table(:raids) do |t|
      t.references :list
    end
  end

  def down
    change_table(:raids) do |t|
      t.remove :list_id
    end
  end
end

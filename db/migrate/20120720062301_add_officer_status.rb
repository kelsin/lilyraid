class AddOfficerStatus < ActiveRecord::Migration
  def up
    change_table(:characters) do |t|
      t.boolean :officer
    end

    change_table(:guilds) do |t|
      t.integer :officer_rank, :default => 1
    end
  end

  def down
    change_table(:characters) do |t|
      t.remove :officer
    end

    change_table(:guilds) do |t|
      t.remove :officer_rank
    end
  end
end

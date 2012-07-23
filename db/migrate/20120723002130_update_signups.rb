class UpdateSignups < ActiveRecord::Migration
  def up
    change_table(:signups) do |t|
      t.integer :roles
    end
  end

  def down
    change_table(:signups) do |t|
      t.remove :roles
    end
  end
end

class UpdateSignups < ActiveRecord::Migration
  def up
    changes_table(:signups) do |t|
      t.integer :roles
    end
  end

  def down
    changes_table(:signups) do |t|
      t.remove :roles
    end
  end
end

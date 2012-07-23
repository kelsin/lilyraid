class UpdateSlots < ActiveRecord::Migration
  def up
    change_table(:slots) do |t|
      t.remove :role_id
      t.remove :cclass_id
      t.remove :closed

      t.integer :roles
      t.integer :classes
    end
  end

  def down
    change_table(:slots) do |t|
      t.references :role
      t.references :cclass
      t.boolean :closed, :null => false, :default => true

      t.remove :roles
      t.remove :classes
    end

    add_index :slots, [:role_id, :cclass_id]
  end
end

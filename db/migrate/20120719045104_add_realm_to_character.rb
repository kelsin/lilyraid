class AddRealmToCharacter < ActiveRecord::Migration
  def up
    change_table(:characters) do |t|
      t.string :realm, :default => 'bronzebeard', :null => false
    end
  end

  def down
    change_table(:characters) do |t|
      t.remove :realm
    end
  end
end

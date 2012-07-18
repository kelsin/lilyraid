class AddCharacterImage < ActiveRecord::Migration
  def up
    change_table(:characters) do |t|
      t.string :thumbnail
    end
  end

  def down
    change_table(:characters) do |t|
      t.remove :thumbnail
    end
  end
end

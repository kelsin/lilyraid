class CreateGuilds < ActiveRecord::Migration
  def change
    create_table :guilds do |t|
      t.string :name, :null => false
      t.string :realm, :null => false
      t.integer :icon
      t.integer :border
      t.string :icon_color
      t.string :border_color
      t.string :background_color
      t.timestamps
    end
  end
end

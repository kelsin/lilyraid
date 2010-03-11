class CreateRaiderTags < ActiveRecord::Migration
  def self.up
    create_table :raider_tags do |t|
      t.references :account
      t.references :raid
      t.timestamps
    end

    change_table(:signups) do |t|
      t.remove :no_show
    end
  end

  def self.down
    change_table(:signups) do |t|
      t.string :no_show, :null => false, :default => 'Showed Up'
    end

    drop_table :raider_tags
  end
end

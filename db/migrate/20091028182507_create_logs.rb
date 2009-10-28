class CreateLogs < ActiveRecord::Migration
  def self.up
    create_table :logs do |t|
      t.references :account
      t.references :character
      t.references :raid
      t.references :loot
      t.string :source
      t.string :message
      t.timestamps
    end
  end

  def self.down
    drop_table :logs
  end
end

class RemoveNotNeededInstanceColumns < ActiveRecord::Migration
  def self.up
    remove_column(:instances, 'requires_key')
    remove_column(:instances, 'max_number')
    remove_column(:instances, 'min_level')
    remove_column(:instances, 'max_level')

    drop_table :attunements
  end

  def self.down
    add_column(:instances, 'requires_key', :boolean, :null => false, :default => false)
    add_column(:instances, 'max_number', :integer)
    add_column(:instances, 'min_level', :integer)
    add_column(:instances, 'max_level', :integer)

    create_table :attunements do |t|
      t.references :character
      t.references :instance
      t.timestamps
    end

    add_index :attunements, :character_id
    add_index :attunements, :instance_id
    add_index :attunements, [:character_id, :instance_id]
  end
end

class CreateTemplates < ActiveRecord::Migration
  def self.up
    create_table :templates do |t|
      t.string :name
      t.timestamps
    end

    change_column(:slots, 'raid_id', :integer, :null => true, :default => nil)
    add_column(:slots, 'template_id', :integer)
  end

  def self.down
    change_column(:slots, 'raid_id', :integer, :null => false)
    remove_column(:slots, 'template_id')
    drop_table :templates
  end
end

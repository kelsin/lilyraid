class RemoveUnusedInstances < ActiveRecord::Migration
  def self.up
    Instance.all.each do |instance|
      if instance.raids.size == 0
        instance.destroy
      end
    end
  end

  def self.down
  end
end

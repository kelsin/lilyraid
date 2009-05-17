class RemoveEmptyInstances < ActiveRecord::Migration
  def self.up
    Instance.all.each do |instance|
      if instance.raids.size < 1
        instance.destroy
      end
    end
  end

  def self.down
  end
end

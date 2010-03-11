class Tag < ActiveRecord::Base
  has_many :raider_tags

  def to_s
    self.name
  end
end

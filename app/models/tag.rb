class Tag < ActiveRecord::Base
  has_many :raider_tags

  default_scope :order => 'name'

  named_scope :deletable, :include => :raider_tags, :conditions => 'raider_tags.id is null'

  def to_s
    self.name
  end
end

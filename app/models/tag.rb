class Tag < ActiveRecord::Base
  has_many :raider_tags

  default_scope :order => 'name'

  scope :deletable, :include => :raider_tags, :conditions => 'raider_tags.id is null'

  def to_s
    self.name
  end

  def slug
    self.name.downcase.gsub(/ +/, '_')
  end
end

class Race < ActiveRecord::Base
  has_many :characters

  default_scope order('name')

  def self.named(name)
    self.first(:conditions => { :name => name })
  end

  # Sort by name by default
  def <=>(o)
    self.name <=> o.name
  end
end

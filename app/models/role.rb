class Role < ActiveRecord::Base
  has_many :cclass_roles, :dependent => :destroy
  has_many :cclasses, :through => :cclass_roles

  has_many :signup_roles, :dependent => :destroy
  has_many :signups, :through => :signup_roles

  def self.named(name)
    self.first(:conditions => { :name => name })
  end

  def <=>(o)
    self.name <=> o.name
  end
end

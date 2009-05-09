class Instance < ActiveRecord::Base
  has_many :locations, :dependent => :nullify
  has_many :raids, :through => :locations
  has_many :loots, :through => :locations

  named_scope :active, { :conditions => { :active => true } }
  named_scope :inactive, { :conditions => { :active => false } }

  default_scope :order => 'name'
end

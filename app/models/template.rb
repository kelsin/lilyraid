class Template < ActiveRecord::Base
  has_many :slots
  accepts_nested_attributes_for :slots, :allow_destroy => true

  default_scope :order => 'templates.name'

  validates_presence_of :name
  validates_uniqueness_of :name

  def types
    slots.count(:include => :role, :group => "roles.name")
  end

  def groups
    slots.each_slice(5)
  end
end

class Template < ActiveRecord::Base
  has_many :slots
  accepts_nested_attributes_for :slots, :allow_destroy => true

  default_scope :order => 'templates.name'

  validates_presence_of :name
  validates_uniqueness_of :name

  validates_numericality_of :number_of_slots, :only_integer => true, :greater_than => 0, :allow_nil => true

  attr_accessor :number_of_slots

  after_create :create_slots

  def types
    slots.count(:include => :role, :group => "roles.name")
  end

  def groups
    slots.each_slice(5)
  end

  def number_of_slots_before_type_cast
    @number_of_slots
  end

  private

  def create_slots
    @number_of_slots.to_i.times do
      self.slots.create
    end
  end
end

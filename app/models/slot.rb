class Slot < ActiveRecord::Base
  belongs_to :raid
  belongs_to :signup

  scope :empty, {
    :conditions => "signup_id is null" }

  scope :filled, {
    :conditions => "signup_id is not null" }

  scope :in_team, lambda { |team| {
      :conditions => { :team => team } } }

  default_scope :order => 'slots.id'

  def eql?(o)
    o.is_a?(Slot) &&
      self.roles == o.roles &&
      self.classes == o.classes
  end

  def hash
    "#{self.roles.to_s}:#{self.classes.to_s}".hash
  end

  def <=>(slot)
    if self.classes > 0 && slot.classes > 0
      # Both have a cclass have to compare
      if self.roles > 0 && slot.roles > 0
        # Both have both
        comp = self.classes <=> slot.classes
        if comp == 0
          self.roles <=> slot.roles
        else
          comp
        end
      elsif self.roles != nil
        -1
      elsif slot.roles != nil
        1
      else
        self.classes <=> slot.classes
      end
    elsif self.classes != nil
      -1
    elsif slot.classes != nil
      1
    else
      # Both don't have a cclass, compare roles
      if self.roles != nil && slot.roles != nil
        # Both have a slot type, compare them
        self.roles <=> slot.roles
      elsif self.roles != nil
        -1
      elsif slot.roles != nil
        1
      else
        0
      end
    end
  end

  def closed?
    self.roles == 0
  end

  def accept(su)
    (self.roles & su.roles) > 0
  end
end

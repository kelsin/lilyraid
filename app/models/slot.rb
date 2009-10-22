class Slot < ActiveRecord::Base
  belongs_to :raid
  belongs_to :template

  belongs_to :signup

  belongs_to :role
  belongs_to :cclass

  named_scope :empty, {
    :conditions => "signup_id is null"
  }

  named_scope :filled, {
    :conditions => "signup_id is not null"
  }

  default_scope :order => 'slots.id'

  named_scope :in_team, lambda { |team| {
      :conditions => { :team => team }
    }
  }

  def eql?(o)
    o.is_a?(Slot) && self.role_id == o.role_id && self.cclass_id == o.cclass_id
  end

  def hash
    "#{self.role.to_s}:#{self.cclass.to_s}".hash
  end

  def <=>(slot)
    if self.cclass != nil && slot.cclass != nil
      # Both have a cclass have to compare
      if self.role != nil && slot.role != nil
        # Both have both
        comp = self.cclass <=> slot.cclass
        if comp == 0
          self.role <=> slot.role
        else
          comp
        end
      elsif self.role != nil
        -1
      elsif slot.role != nil
        1
      else
        self.cclass <=> slot.cclass
      end
    elsif self.cclass != nil
      -1
    elsif slot.cclass != nil
      1
    else
      # Both don't have a cclass, compare roles
      if self.role != nil && slot.role != nil
        # Both have a slot type, compare them
        self.role <=> slot.role
      elsif self.role != nil
        -1
      elsif slot.role != nil
        1
      else
        0
      end
    end
  end            

  def accept(su)
    if role == nil and cclass == nil
      true
    elsif cclass == nil and su.roles.member?(role)
      true
    elsif role == nil and cclass == su.character.cclass
      true
    elsif su.roles.member?(role) and cclass == su.character.cclass
      true
    else
      false
    end            
  end

  def accepts
    a = []
    
    (role ? [role] : Role.all).each do |r|
      (cclass ? [cclass] : r.cclasses).each do |c|
        a.push(".#{r.name.downcase}.#{c.name.downcase.sub(/ /, '_')}")
      end
    end

    a.join(", ")
  end

  def display
    if role == nil and cclass == nil
      "Open"
    elsif role == nil
      cclass.to_s
    elsif cclass == nil
      role.to_s
    else
      "#{cclass} #{role}"
    end
  end
end

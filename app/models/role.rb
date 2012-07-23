class Role
  NUMBER = 3
  ALL = 7
  TANK = 0
  HEAL = 1
  DPS = 2

  def self.all
    [TANK, HEAL, DPS]
  end

  def self.to_array(mask)
    return [] if mask.nil?
    (0...NUMBER).inject([]) do |roles, role|
      roles << role if (mask & (2**role)) > 0
      roles
    end
  end

  def self.to_mask(roles)
    roles.inject(0) do |num, role|
      num + (2**role)
    end
  end

  def self.mask_for_class(class_id)
    
  end
end
